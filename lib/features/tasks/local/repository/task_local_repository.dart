

import 'dart:developer';

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

  List<Task> getFilteredTasks({
    String? searchKey,
    String? sortBy, 
    String? sortOrder, 
    String? status,
    String? categoryId,
  }) {
    List<Task> tasks = getAllTasks();

    
    if (status != null && status.isNotEmpty) {
      tasks = tasks.where((t) => t.status.name == status).toList();
    }

   
    if (categoryId != null && categoryId.isNotEmpty) {
      tasks = tasks.where((t) => t.categoryId == categoryId).toList();
    }

    
    if (searchKey != null && searchKey.isNotEmpty) {
      tasks = tasks
          .where((t) =>
              t.title.toLowerCase().contains(searchKey.toLowerCase().trim()))
          .toList();
    }

    
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
            case 'priority':
            Map<String, int> priorityOrder = {
          'HIGH': 3,
          'MEDIUM': 2,
          'LOW': 1,
        };
        valueA = priorityOrder[a.priority] ?? 0;
        valueB = priorityOrder[b.priority] ?? 0;
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

  
  Task? getTaskById(String taskId) {
    final taskHive = tasksBox.get(taskId);
    return taskHive?.toTask();
  }
}