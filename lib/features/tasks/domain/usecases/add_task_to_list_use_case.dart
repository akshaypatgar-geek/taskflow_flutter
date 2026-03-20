// Not required: Tasks are added via WebSocket stream (TaskCreatedEvent) in TasksBloc.
// Kept for reference if a manual add flow is needed later.
//
// import 'package:taskflowapp/features/tasks/domain/repository/tasks_repository_interface.dart';
// import '../entities/task_entity/task_entity.dart';
//
// class AddTaskToListUseCase {
//   final TasksRepository _repository;
//   AddTaskToListUseCase({required TasksRepository repository}) : _repository = repository;
//   Future<TaskEntity> call() async {}
// }
