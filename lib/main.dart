import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:taskflowapp/core/config/app_config.dart';
import 'package:taskflowapp/core/injection/injection.dart';
import 'package:taskflowapp/core/network/bloc/network_bloc.dart';
import 'package:taskflowapp/core/notifications/notification_service.dart';
import 'package:taskflowapp/core/routes/router.dart';
import 'package:taskflowapp/core/theme/app_theme.dart';
import 'package:taskflowapp/core/theme/theme_mode_controller.dart';
import 'package:taskflowapp/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:taskflowapp/firebase_options.dart';
import 'package:taskflowapp/hive_registrar.g.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:taskflowapp/core/offline/service/background_sync_service.dart';
import 'core/offline/offline_request_hive.dart';
import 'features/categories/local/model/category_hive/category_hive.dart';
import 'features/profile/data/datasources/local/model/user_details_hive.dart';
import 'features/tasks/local/model/task_hive/task_hive.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await _initialiseServices();
  await AppConfig.init();
  await initInjector();
  
  // Initialize background sync
  await BackgroundSyncService.initialize();
  await BackgroundSyncService.schedulePeriodicSync();

  runApp(const MyApp());
}

Future<void> _initialiseServices() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapters();
  await Hive.openBox<UserDetailsHive>('userBox');
  await Hive.openBox<CategoryHive>('categories');
  await Hive.openBox<TaskHive>('tasks');
  await Hive.openBox<OfflineRequestHive>('offlineRequests');
  await ThemeModeController.loadSavedThemeMode();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _router = Routes(_authBloc).router;
    
    // Initialize notifications
    sl<NotificationService>().initialize(_router);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<NetworkBloc>()),
        BlocProvider.value(value: _authBloc),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSessionExpired) {
            sl<TasksBloc>().add(ResetTasksEvent());
            _messengerKey.currentState?.showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthAuthenticated) {
            // Call setupToken after successful sign in
            sl<NotificationService>().setupToken();
          }
        },
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeModeController.themeMode,
          builder: (context, themeMode, _) {
            return MaterialApp.router(
              scaffoldMessengerKey: _messengerKey,
              title: 'Taskflow',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeMode,
              routerConfig: _router,
              builder: (context, child) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: child ?? const SizedBox.shrink(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
