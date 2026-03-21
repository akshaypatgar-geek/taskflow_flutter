import 'package:go_router/go_router.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/task/task_bloc.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';

import '../../features/tasks/domain/entities/task_entity/task_entity.dart';


extension RouteExtraX on GoRouterState {
  TaskFormExtra? get taskFormExtra =>
      extra is TaskFormExtra ? extra as TaskFormExtra : null;

  TaskDetailExtra? get taskDetailExtra =>
      extra is TaskDetailExtra ? extra as TaskDetailExtra : null;
}


sealed class TaskFormExtra {
  const TaskFormExtra();
}


final class CreateTaskFormExtra extends TaskFormExtra {
  const CreateTaskFormExtra(this.tasksBloc);
  final TasksBloc tasksBloc;
}


final class EditTaskFormExtra extends TaskFormExtra {
  const EditTaskFormExtra(this.task, this.taskBloc);
  final TaskEntity task;
  final TaskBloc taskBloc;
}


final class TaskDetailExtra {
  const TaskDetailExtra(this.tasksBloc);
  final TasksBloc tasksBloc;
}
