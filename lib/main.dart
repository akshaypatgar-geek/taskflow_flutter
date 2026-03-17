import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:taskflowapp/core/network/bloc/network_bloc.dart';
import 'package:taskflowapp/core/network/network_repository.dart';
import 'package:taskflowapp/core/network/network_service.dart';
import 'package:taskflowapp/core/offline/offline_request_hive.dart';
import 'package:taskflowapp/core/offline/repository/offline_request_repository.dart';
import 'package:taskflowapp/core/offline/service/offline_service.dart';
import 'package:taskflowapp/hive_registrar.g.dart';

import 'core/network/dio_client.dart';
import 'core/routes/routers.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/repository/auth_repository.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/categories/data/repository/category_repository.dart';
import 'features/categories/local/model/category_hive/category_hive.dart';
import 'features/categories/services/category_service.dart';
import 'features/profile/local/model/user_details_hive.dart';
import 'features/session_manager/session_manager.dart';
import 'features/tasks/local/model/task_hive/task_hive.dart';
import 'core/websocket/socket_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await _initialiseServices();
  await dotenv.load(fileName: ".env");
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
  create: (_) => const FlutterSecureStorage(),
),
         RepositoryProvider(create: (ctx) =>DioClient(storage: ctx.read<FlutterSecureStorage>())),
        RepositoryProvider(
      create: (ctx) => SessionManager(
        storage: ctx.read<FlutterSecureStorage>(),
      ),
      
    ),
       
        RepositoryProvider(create: (ctx)=>AuthRepository(
          client: ctx.read<DioClient>(),
          sessionManager: ctx.read<SessionManager>()
        )),
         
         RepositoryProvider(
                  create: (context) =>
                      CategoryRepository(client: context.read<DioClient>()),
                ),
                RepositoryProvider(
                  create: (context) => CategoryService(
                    repository: context.read<CategoryRepository>(),
                  ),
                ),
                RepositoryProvider(create: (ctx)=>OfflineRequestRepository(offlineBox: Hive.box<OfflineRequestHive>('offlineRequests'),client: ctx.read<DioClient>())),
                RepositoryProvider(create: (ctx)=>NetworkService()),
                RepositoryProvider(create: (ctx)=>NetworkRepository(service: ctx.read<NetworkService>())),
                RepositoryProvider(create: (ctx)=>SocketService()),
                RepositoryProvider(create: (ctx)=>OfflineSyncService(ctx.read<OfflineRequestRepository>()))
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (ctx)=>NetworkBloc(repository: ctx.read<NetworkRepository>())..add(StartNetworkMonitoring())),
          BlocProvider(create: (ctx) => AuthBloc(repository: ctx.read<AuthRepository>())..add(CheckSessionEvent()),)
        ],

      child: Builder(
        builder: (context) {
          final authBloc = context.read<AuthBloc>();
            final routes = Routes(authBloc);
          return MaterialApp.router(
            title: 'Taskflow',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            routerConfig: routes.router,
          );
        }
      ),
    ));
  }
}

