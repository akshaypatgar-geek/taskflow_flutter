import 'package:hive_ce_flutter/adapters.dart';
import 'package:taskflowapp/features/tasks/data/datasource/local/tasks_datasource_local.dart';
import 'package:taskflowapp/features/tasks/data/model/task_model/task_model.dart';
import 'package:taskflowapp/features/tasks/local/model/task_hive/task_hive.dart';


class TasksDatasourceLocalImpl implements TasksDatasourceLocal{
  final Box<TaskHive> taskBox;

  TasksDatasourceLocalImpl({required this.taskBox});

  @override
  Future<TaskModel?> getTaskById(String taskId) async {
    final hive = taskBox.get(taskId);
    return hive?.toTask();
  }

  @override
  Future<List<TaskModel>?> listUserTasks({String? searchKey, String? status, String sortBy = 'date', String sortOrder = 'desc', String? cursor, int limit = 10, String? categoryId,}) async{
       Iterable<TaskHive> filtered = taskBox.values;

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

    final List<TaskModel> tasks = filtered.map((e) => e.toTask()).toList();

    
      const priorityOrder = {'HIGH': 3, 'MEDIUM': 2, 'LOW': 1};
      tasks.sort((a, b) {
        Comparable valueA;
        Comparable valueB;
        switch (sortBy) {
          case 'title':
            valueA = a.title;
            valueB = b.title;
            break;
          case 'status':
            valueA = a.status.name;
            valueB = b.status.name;
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

    return tasks.take(limit).toList();
  }

  @override
  Future<void> addTaskToHive({required TaskModel task}) async{
    await taskBox.put(task.taskId, TaskHive.fromTask(task));
  }
  
  @override
  Future<void> deleteTaskFromHive({required String taskId}) async{
    final TaskHive? existing = taskBox.get(taskId);
    if(existing !=null) {
      taskBox.delete(taskId);
    }
  }
}