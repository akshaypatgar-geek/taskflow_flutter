import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflowapp/core/injection/injection.dart';
import 'package:taskflowapp/core/network/bloc/network_bloc.dart';
import 'package:taskflowapp/core/routes/routers.dart';
import 'package:taskflowapp/core/theme/app_theme.dart';
import 'package:taskflowapp/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:taskflowapp/hive_registrar.g.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'core/offline/offline_request_hive.dart';
import 'features/categories/local/model/category_hive/category_hive.dart';
import 'features/profile/data/datasources/local/model/user_details_hive.dart';
import 'features/tasks/local/model/task_hive/task_hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initialiseServices();
  await dotenv.load(fileName: ".env");
  await initInjector();
  runApp(const MyApp());
}

Future<void> _initialiseServices() async {
  await Hive.initFlutter();
  Hive.registerAdapters();
  await Hive.openBox<UserDetailsHive>('userBox');
  await Hive.openBox<CategoryHive>('categories');
  await Hive.openBox<TaskHive>('tasks');
  await Hive.openBox<OfflineRequestHive>('offlineRequests');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<NetworkBloc>()),
        BlocProvider.value(value: sl<AuthBloc>()),
      ],
      child: Builder(
        builder: (context) {
          final authBloc = sl<AuthBloc>();
          final routes = Routes(authBloc);
          return MaterialApp.router(
            title: 'Taskflow',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            routerConfig: routes.router,
          );
        },
      ),
    );
  }
}
