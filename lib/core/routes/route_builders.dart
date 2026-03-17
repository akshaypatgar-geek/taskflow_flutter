import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/core/offline/repository/offline_request_repository.dart';
import 'package:taskflowapp/features/tasks/local/model/task_hive/task_hive.dart';
import 'package:taskflowapp/features/tasks/presentation/screen/task_details_screen.dart';
import 'package:taskflowapp/features/tasks/presentation/screen/task_form_screen.dart';
import 'package:taskflowapp/features/tasks/presentation/screen/tasks_screen.dart';
import 'package:taskflowapp/core/websocket/socket_service.dart';

import '../../features/categories/services/category_service.dart';
import '../../features/tasks/data/repository/task_repository.dart';
import '../../features/tasks/data/repository/tasks_repository.dart';
import '../../features/tasks/local/repository/task_local_repository.dart';
import '../../features/tasks/presentation/bloc/task/task_bloc.dart';
import '../../features/tasks/presentation/bloc/tasks/tasks_bloc.dart';
import 'route_extras.dart';

/// Builds the tasks list screen with its dependencies.
class TasksRouteBuilder {
  static Widget build(BuildContext context, GoRouterState state) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (ctx) => TasksRepository(client: ctx.read<DioClient>()),
        ),
        RepositoryProvider(
          create: (ctx) => LocalTasksRepository(
            tasksBox: Hive.box<TaskHive>('tasks'),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => TasksBloc(
          localRepo: context.read<LocalTasksRepository>(),
          repository: context.read<TasksRepository>(),
        )..add(ListUserTasks()),
        child: TasksScreen(
          categoryService: context.read<CategoryService>(),
        ),
      ),
    );
  }
}

/// Builds the task form screen (create or edit) with typed [TaskFormExtra].
class TaskFormRouteBuilder {
  static Widget build(BuildContext context, GoRouterState state) {
    final extra = state.extra;
    if (extra is! TaskFormExtra) {
      return const _InvalidRoutePlaceholder(message: 'Task form: missing extra');
    }

    return switch (extra) {
      CreateTaskFormExtra(:final tasksBloc) => _buildCreate(
          context,
          tasksBloc: tasksBloc,
        ),
      EditTaskFormExtra(:final task, :final taskBloc) => BlocProvider.value(
          value: taskBloc,
          child: Builder(
            builder: (ctx) => TaskFormWidget(
              task: task,
              categoryService: ctx.read<CategoryService>(),
            ),
          ),
        ),
    };
  }

  static Widget _buildCreate(BuildContext context, {required TasksBloc tasksBloc}) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (ctx) => TaskRepository(
            client: ctx.read<DioClient>(),
            offlineRequestRepository: ctx.read<OfflineRequestRepository>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: tasksBloc),
          BlocProvider(
            create: (ctx) => TaskBloc(
              repository: ctx.read<TaskRepository>(),
              socketService: ctx.read<SocketService>(),
              localRepository: tasksBloc.localRepo,
            ),
          ),
        ],
        child: Builder(
          builder: (ctx) => TaskFormWidget(
            task: null,
            categoryService: ctx.read<CategoryService>(),
          ),
        ),
      ),
    );
  }
}

/// Builds the task detail screen with typed [TaskDetailExtra].
class TaskDetailRouteBuilder {
  static Widget build(BuildContext context, GoRouterState state) {
    final id = state.pathParameters['id'] ?? '';
    final extra = state.extra;
    if (extra is! TaskDetailExtra) {
      return const _InvalidRoutePlaceholder(
        message: 'Task detail: missing extra',
      );
    }

    return RepositoryProvider(
      create: (ctx) => TaskRepository(
        client: ctx.read<DioClient>(),
        offlineRequestRepository: ctx.read<OfflineRequestRepository>(),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: extra.tasksBloc),
          BlocProvider(
            create: (ctx) => TaskBloc(
              repository: ctx.read<TaskRepository>(),
              socketService: ctx.read<SocketService>(),
              localRepository: extra.tasksBloc.localRepo,
            )..add(GetTaskDetails(taskId: id)),
          ),
        ],
        child: TaskDetailsScreen(
          taskId: id,
          categoryService: context.read<CategoryService>(),
        ),
      ),
    );
  }
}

class _InvalidRoutePlaceholder extends StatelessWidget {
  const _InvalidRoutePlaceholder({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(message),
      ),
    );
  }
}
