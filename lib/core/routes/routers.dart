import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/features/categories/data/repository/category_repository.dart';
import 'package:taskflowapp/features/tasks/presentation/screen/task_details_screen.dart';
import 'package:taskflowapp/features/tasks/presentation/screen/task_form_screen.dart';
import 'package:taskflowapp/services/websocket/Socket_service.dart';

import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/auth/presentation/screen/landing_screen.dart';
import '../../features/auth/presentation/screen/log_in_screen.dart';
import '../../features/auth/presentation/screen/sign_up_screen.dart';
import '../../features/categories/services/category_service.dart';
import '../../features/profile/presentation/screen/profile_screen.dart';
import '../../features/tasks/data/model/task/task.dart';
import '../../features/tasks/data/repository/task_repository.dart';
import '../../features/tasks/presentation/bloc/task/task_bloc.dart';
import '../../features/tasks/presentation/bloc/tasks/tasks_bloc.dart';
import '../../features/tasks/presentation/screen/tasks_screen.dart';
import 'go_router_refresh_stream.dart';

class Routes {
  final AuthBloc authBloc;

  Routes(this.authBloc);
 GoRouter get router => GoRouter(
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(authBloc.stream),
    
    redirect: (context, state) {
      final authState = authBloc.state;
      final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

      if (authState is AuthUnauthenticated) {
        return loggingIn ? null : '/login';
      }

      if (authState is AuthAuthenticated) {
        if (loggingIn) return '/tasks';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: "logIn",
        builder: (context, state) => const LogInScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: "signUp",
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/tasks',
        name: "tasks",
        builder: (context, state) => const TasksScreen(),
      ),
      GoRoute(path: '/task_form',
      name: "taskForm",
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
    final task = extra['task'] as Task?;
    var bloc = extra['bloc'];
    if(task !=null) {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context)=>CategoryRepository(client: context.read<DioClient>())),
          RepositoryProvider(create: (context)=>CategoryService(repository: context.read<CategoryRepository>()))
        ],
        child: BlocProvider.value(
            value: bloc as TaskBloc,
            child: Builder(
              builder: (context) {
                return TaskFormWidget(
                  task: task,
                  categoryService: context.read<CategoryService>(),
                  );
              }
            ),
          ),
      );
    } else {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context)=>CategoryRepository(client: context.read<DioClient>())),
          RepositoryProvider(create: (context)=>CategoryService(repository: context.read<CategoryRepository>())),
          RepositoryProvider(create: (context)=>TaskRepository(client: context.read<DioClient>()))
        
        ],
    
        child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: bloc as TasksBloc),
              BlocProvider(create: (context) => TaskBloc(
            repository: context.read<TaskRepository>(),
            socketService: context.read<SocketService>()
                  ),)
            ],
            child: Builder(
              builder: (context) {
                return TaskFormWidget(
                task: task,
                categoryService: context.read<CategoryService>(),
                );
              }
            ),
          ),);
    }
    
      
    
      },),
      GoRoute(path: '/task/:id',
      name: "taskDetail",
      builder: (context, state) {
        String id = state.pathParameters['id']??"";
        final tasksBloc = state.extra as TasksBloc;
        return RepositoryProvider(
          create: (context) => TaskRepository(client: context.read<DioClient>()),
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: tasksBloc),
              BlocProvider(create: (context) => TaskBloc(
            repository: context.read<TaskRepository>(),
            socketService: context.read<SocketService>()
                  )..add(GetTaskDetails(taskId: id)),)
            ],
            child: TaskDetailsScreen(taskId: id),
          ),
        );
      },
      ),
      GoRoute(path: '/profile',
      name: "profile",
      builder: (context, state) => ProfileScreen(),)
    ],
  );
}