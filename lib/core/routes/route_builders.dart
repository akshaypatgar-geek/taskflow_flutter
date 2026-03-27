import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/domain/connect_websocket_use_case.dart';
import 'package:taskflowapp/core/injection/injection.dart';
import 'package:taskflowapp/features/categories/domain/usecases/get_cached_categories_use_case.dart';
import 'package:taskflowapp/features/categories/domain/usecases/get_category_details_use_case.dart';
import 'package:taskflowapp/features/categories/domain/usecases/list_categories_use_case.dart';
import 'package:taskflowapp/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:taskflowapp/features/categories/presentation/screen/categories_screen.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/task/task_bloc.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:taskflowapp/features/tasks/presentation/screen/task_details_screen.dart';
import 'package:taskflowapp/features/tasks/presentation/screen/task_form_screen.dart';
import 'package:taskflowapp/features/tasks/presentation/screen/tasks_screen.dart';
import 'package:taskflowapp/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:taskflowapp/features/profile/presentation/screen/profile_screen.dart';
import '../theme/app_tokens.dart';
import 'route_extras.dart';
import 'router.dart';


class TasksRouteBuilder {
  static Widget build(BuildContext context, GoRouterState state) {
    final tasksBloc = sl<TasksBloc>()..add(ListUserTasks());
    return BlocProvider.value(
      value: tasksBloc,
      child: TasksScreen(
        getCachedCategoriesUseCase: sl<GetCachedCategoriesUseCase>(),
        listCategoriesUseCase: sl<ListCategoriesUseCase>(),
        connectWebSocketUseCase: sl<ConnectWebSocketUseCase>(),
      ),
    );
  }
}

/// Builds the task form screen (create or edit) with typed [TaskFormExtra].
class TaskFormRouteBuilder {
  static Widget build(BuildContext context, GoRouterState state) {
    final extra = state.taskFormExtra;
    if (extra == null) {
      return const _InvalidRoutePlaceholder(message: 'Task form: missing extra');
    }

    return switch (extra) {
      CreateTaskFormExtra(:final tasksBloc) => _buildCreate(
          context,
          tasksBloc: tasksBloc,
        ),
      EditTaskFormExtra(:final task, :final taskBloc) => BlocProvider.value(
          value: taskBloc,
          child: TaskFormWidget(
            task: task,
            listCategoriesUseCase: sl<ListCategoriesUseCase>(),
          ),
        ),
    };
  }

  static Widget _buildCreate(BuildContext context, {required TasksBloc tasksBloc}) {
    final taskBloc = sl<TaskBloc>();
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: tasksBloc),
        BlocProvider.value(value: taskBloc),
      ],
      child: TaskFormWidget(
        task: null,
        listCategoriesUseCase: sl<ListCategoriesUseCase>(),
      ),
    );
  }
}

/// Builds the task detail screen with typed [TaskDetailExtra].
class TaskDetailRouteBuilder {
  static Widget build(BuildContext context, GoRouterState state) {
    final id = state.pathParameters['id'] ?? '';
    final extra = state.taskDetailExtra;
    if (extra == null) {
      return const _InvalidRoutePlaceholder(
        message: 'Task detail: missing extra',
      );
    }

    final taskBloc = sl<TaskBloc>()..add(GetTaskDetails(taskId: id));
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: extra.tasksBloc),
        BlocProvider.value(value: taskBloc),
      ],
      child: TaskDetailsScreen(
        taskId: id,
        getCategoryDetailsUseCase: sl<GetCategoryDetailsUseCase>(),
      ),
    );
  }
}

/// Builds the profile screen with its dependencies.
class ProfileRouteBuilder {
  static Widget build(BuildContext context, GoRouterState state) {
    final profileBloc = sl<ProfileBloc>()..add(GetProfileDetailsEvent());
    return BlocProvider.value(
      value: profileBloc,
      child: const ProfileScreen(),
    );
  }
}

/// Builds the categories screen with its dependencies.
class CategoriesRouteBuilder {
  static Widget build(BuildContext context, GoRouterState state) {
    final categoriesBloc = sl<CategoriesBloc>()..add(LoadCategories());
    return BlocProvider.value(
      value: categoriesBloc,
      child: const CategoriesScreen(),
    );
  }
}

class _InvalidRoutePlaceholder extends StatelessWidget {
  const _InvalidRoutePlaceholder({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed(ScreenPaths.tasks.name);
            }
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: AppTokens.routeErrorIconSize),
            const SizedBox(height: AppTokens.sXl),
            Text(message),
          ],
        ),
      ),
    );
  }
}
