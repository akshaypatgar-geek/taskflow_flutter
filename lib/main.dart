import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:taskflowapp/core/network/network_service.dart';
import 'package:taskflowapp/core/offline/offline_request_hive.dart';
import 'package:taskflowapp/core/offline/repository/offline_request_repository.dart';
import 'package:taskflowapp/core/offline/service/offline_service.dart';
import 'package:taskflowapp/hive_registrar.g.dart';

import 'core/network/dio_client.dart';
import 'core/routes/routers.dart';
import 'features/auth/data/repository/auth_repository.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/categories/data/repository/category_repository.dart';
import 'features/categories/local/model/category_hive/category_hive.dart';
import 'features/categories/services/category_service.dart';
import 'features/profile/local/model/user_details_hive.dart';
import 'features/session_manager/session_manager.dart';
import 'features/tasks/local/model/task_hive/task_hive.dart';
import 'services/websocket/Socket_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await _initialiseServices();
  runApp(const MyApp());
}

Future<void> _initialiseServices() async {
  await Hive.initFlutter();
  // Hive.registerAdapter(UserDetailsHiveAdapter());
  
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
         RepositoryProvider(create: (ctx) =>DioClient()),
        RepositoryProvider(
      create: (ctx) => SessionManager(
        storage: const FlutterSecureStorage(),
      ),
      
    ),
       
        RepositoryProvider(create: (ctx)=>AuthRepository(
          client: ctx.read<DioClient>(),
          sessionManager: ctx.read<SessionManager>()
        )),
         RepositoryProvider(create: (ctx)=>SocketService()),
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
                RepositoryProvider(create: (ctx)=>OfflineSyncService(ctx.read<OfflineRequestRepository>()))
      ],
      child: BlocProvider<AuthBloc>(
        create: (ctx) => AuthBloc(repository: ctx.read<AuthRepository>())..add(CheckSessionEvent()),
      child: Builder(
        builder: (context) {
          final authBloc = context.read<AuthBloc>();

            // Pass it to Routes
            final routes = Routes(authBloc);


          return MaterialApp.router(
            title: 'Taskflow',
            debugShowCheckedModeBanner: false,
            routerConfig: routes.router,
            theme: ThemeData(
              
              colorScheme: .fromSeed(seedColor: Colors.deepPurple),
            ),
            
          );
        }
      ),
    ));
  }
}

