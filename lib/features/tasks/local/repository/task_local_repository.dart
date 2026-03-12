

import 'dart:developer';

import 'package:hive_ce/hive.dart';

import '../../data/model/task/task.dart';
import '../model/task_hive/task_hive.dart';

class LocalTasksRepository {
  final Box<TaskHive> tasksBox;

  LocalTasksRepository({required this.tasksBox});

  /// Add or update a task
  Future<void> saveTask(Task task) async {
    log("new task id :${task.taskId}");
    await tasksBox.put(task.taskId, TaskHive.fromTask(task));
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final Map<String, TaskHive> obj = {for(var e in tasks)e.taskId : TaskHive.fromTask(e) };
    await tasksBox.putAll(obj);
  }

  /// Remove a task
  Future<void> deleteTask(String taskId) async {
    await tasksBox.delete(taskId);
  }

  /// Get all tasks
  List<Task> getAllTasks() {
    return tasksBox.values.map((e) => e.toTask()).toList();
  }

  /// Filtering, searching, and sorting
  List<Task> getFilteredTasks({
    String? searchKey,
    String? sortBy, // "title", "status", etc.
    String? sortOrder, // "asc" or "desc"
    String? status,
    String? categoryId,
  }) {
    log("sort :$sortOrder $sortBy");
    List<Task> tasks = getAllTasks();

    // Filter by status
    if (status != null && status.isNotEmpty) {
      tasks = tasks.where((t) => t.status.name == status).toList();
    }

    // Filter by category
    if (categoryId != null && categoryId.isNotEmpty) {
      tasks = tasks.where((t) => t.categoryId == categoryId).toList();
    }

    // Search by title or description
    if (searchKey != null && searchKey.isNotEmpty) {
      tasks = tasks
          .where((t) =>
              t.title.toLowerCase().contains(searchKey.toLowerCase()))
          .toList();
    }

    // Sort
    if (sortBy != null) {
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
          default:
            valueA = a.title;
            valueB = b.title;
        }

        if (sortOrder == 'desc') {
          return valueB.toString().compareTo(valueA.toString());
        }
        return valueA.toString().compareTo(valueB.toString());
      });
    }

    return tasks;
  }

  /// Get a single task
  Task? getTaskById(String taskId) {
    final taskHive = tasksBox.get(taskId);
    return taskHive?.toTask();
  }
}