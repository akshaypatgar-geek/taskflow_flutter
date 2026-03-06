import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/network/dio_client.dart';
import 'core/routes/routers.dart';
import 'features/auth/data/repository/auth_repository.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/session_manager/session_manager.dart';
import 'services/websocket/Socket_service.dart';

void main() {
  runApp(const MyApp());
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
         RepositoryProvider(create: (ctx)=>SocketService())
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

