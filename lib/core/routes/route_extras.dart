import 'package:taskflowapp/features/tasks/data/model/task/task.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/task/task_bloc.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';

/// Type-safe extra for task form route (create or edit).
sealed class TaskFormExtra {
  const TaskFormExtra();
}

/// Create new task: pass [TasksBloc] to add the new task to the list on success.
final class CreateTaskFormExtra extends TaskFormExtra {
  const CreateTaskFormExtra(this.tasksBloc);
  final TasksBloc tasksBloc;
}

/// Edit existing task: pass [Task] and [TaskBloc].
final class EditTaskFormExtra extends TaskFormExtra {
  const EditTaskFormExtra(this.task, this.taskBloc);
  final Task task;
  final TaskBloc taskBloc;
}

/// Type-safe extra for task detail route.
final class TaskDetailExtra {
  const TaskDetailExtra(this.tasksBloc);
  final TasksBloc tasksBloc;
}
