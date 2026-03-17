import 'package:hive_ce/hive.dart';

import '../../data/model/task/task.dart';
import '../model/task_hive/task_hive.dart';

class LocalTasksRepository {
  final Box<TaskHive> tasksBox;

  LocalTasksRepository({required this.tasksBox});

  
  Future<void> saveTask(Task task) async {
 
    await tasksBox.put(task.taskId, TaskHive.fromTask(task));
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final Map<String, TaskHive> obj = {for(var e in tasks)e.taskId : TaskHive.fromTask(e) };
    await tasksBox.putAll(obj);
  }

  Future<void> deleteTask(String taskId) async {
    await tasksBox.delete(taskId);
  }

  List<Task> getAllTasks() {
    return tasksBox.values.map((e) => e.toTask()).toList();
  }

  /// Filters and sorts without loading all tasks into memory first.
  List<Task> getFilteredTasks({
    String? searchKey,
    String? sortBy,
    String? sortOrder,
    String? status,
    String? categoryId,
  }) {
    Iterable<TaskHive> filtered = tasksBox.values;

    if (status != null && status.isNotEmpty) {
      filtered = filtered.where((e) => e.status == status);
    }
    if (categoryId != null && categoryId.isNotEmpty) {
      filtered = filtered.where((e) => e.categoryId == categoryId);
    }
    if (searchKey != null && searchKey.isNotEmpty) {
      final key = searchKey.toLowerCase().trim();
      filtered = filtered.where(
        (e) => e.title.toLowerCase().contains(key),
      );
    }

    List<Task> tasks = filtered.map((e) => e.toTask()).toList();

    if (sortBy != null) {
      const priorityOrder = {'HIGH': 3, 'MEDIUM': 2, 'LOW': 1};
      tasks.sort((a, b) {
        dynamic valueA;
        dynamic valueB;
        switch (sortBy) {
          case 'title':
            valueA = a.title;
            valueB = b.title;
            break;
          case 'status':
            valueA = a.status;
            valueB = b.status;
            break;
          case 'date':
            valueA = a.createdAt;
            valueB = b.createdAt;
            break;
          case 'priority':
            valueA = priorityOrder[a.priority] ?? 0;
            valueB = priorityOrder[b.priority] ?? 0;
            break;
          default:
            valueA = a.title;
            valueB = b.title;
        }
        final cmp = valueA.toString().compareTo(valueB.toString());
        return sortOrder == 'desc' ? -cmp : cmp;
      });
    }

    return tasks;
  }

  
  Task? getTaskById(String taskId) {
    final taskHive = tasksBox.get(taskId);
    return taskHive?.toTask();
  }
}