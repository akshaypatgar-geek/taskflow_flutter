import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/core/offline/repository/offline_request_repository.dart';
import 'package:taskflowapp/features/tasks/local/model/task_hive/task_hive.dart';
import 'package:taskflowapp/features/tasks/presentation/screen/task_details_screen.dart';
import 'package:taskflowapp/features/tasks/presentation/screen/task_form_screen.dart';
import 'package:taskflowapp/services/websocket/socket_service.dart';

import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/auth/presentation/screen/landing_screen.dart';
import '../../features/auth/presentation/screen/log_in_screen.dart';
import '../../features/auth/presentation/screen/sign_up_screen.dart';
import '../../features/categories/services/category_service.dart';
import '../../features/profile/presentation/screen/profile_screen.dart';
import '../../features/tasks/data/model/task/task.dart';
import '../../features/tasks/data/repository/task_repository.dart';
import '../../features/tasks/data/repository/tasks_repository.dart';
import '../../features/tasks/local/repository/task_local_repository.dart';
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
      final loggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (authState is AuthUnauthenticated) {
        return loggingIn ? null : '/login';
      }

      if (authState is AuthAuthenticated) {
        if (loggingIn) return '/tasks';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/',
      name: "landing",
       builder: (context, state) => const LandingScreen()),
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
        builder: (context, state) => MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (ctx) => TasksRepository(client: ctx.read<DioClient>()),
            ),
            RepositoryProvider(create: (ctx)=>LocalTasksRepository(
              tasksBox: Hive.box<TaskHive>('tasks')
            ))
          ],
          child: BlocProvider(
            create: (context) => TasksBloc(
              localRepo: context.read<LocalTasksRepository>(),
              repository: context.read<TasksRepository>())..add(ListUserTasks()),
            child:  TasksScreen(categoryService: context.read<CategoryService>(),),
          ),
        ),
      ),
      GoRoute(
        path: '/task_form',
        name: "taskForm",
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final task = extra['task'] as Task?;
          var bloc = extra['bloc'];
          if (task != null) {
            return BlocProvider.value(
              value: bloc as TaskBloc,
              child: Builder(
                builder: (context) {
                  return TaskFormWidget(
                    task: task,
                    categoryService: context.read<CategoryService>(),
                  );
                },
              ),
            );
          } else {
            return MultiRepositoryProvider(
              providers: [
                
                RepositoryProvider(
                  create: (context) =>
                      TaskRepository(client: context.read<DioClient>(),
                      offlineRequestRepository: context.read<OfflineRequestRepository>()
                      ),
                ),
              ],

              child: MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: bloc as TasksBloc),
                  BlocProvider(
                    create: (context) => TaskBloc(
                      repository: context.read<TaskRepository>(),
                      socketService: context.read<SocketService>(),
                      localRepository: bloc.localRepo
                    ),
                  ),
                ],
                child: Builder(
                  builder: (context) {
                    return TaskFormWidget(
                      task: task,
                      categoryService: context.read<CategoryService>(),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
      GoRoute(
        path: '/task/:id',
        name: "taskDetail",
        builder: (context, state) {
          String id = state.pathParameters['id'] ?? "";
          final tasksBloc = state.extra as TasksBloc;
          return RepositoryProvider(
            create: (context) =>
                TaskRepository(client: context.read<DioClient>(),
                offlineRequestRepository: context.read<OfflineRequestRepository>()
               ),
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: tasksBloc),
                BlocProvider(
                  create: (context) => TaskBloc(
                    repository: context.read<TaskRepository>(),
                    socketService: context.read<SocketService>(),
                    localRepository: tasksBloc.localRepo
                  )..add(GetTaskDetails(taskId: id)),
                ),
              ],
              child: TaskDetailsScreen(taskId: id, categoryService: context.read<CategoryService>(),),
            ),
          );
        },
      ),
      GoRoute(
        path: '/profile',
        name: "profile",
        builder: (context, state) => ProfileScreen(),
      ),
    ],
  );
}
