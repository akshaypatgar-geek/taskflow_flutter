
import 'package:hive_ce/hive.dart';
import 'package:taskflowapp/core/utils/enums.dart';

import '../../../data/model/task/task.dart';

part 'task_hive.g.dart';

@HiveType(typeId: 2)
class TaskHive {
  @HiveField(0)
  String taskId;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  DateTime updatedAt;

  @HiveField(4)
  String authorId;

  @HiveField(5)
  String? categoryId;
  
  @HiveField(6)
  String? priority;

  @HiveField(7)
  String? status;

  @HiveField(8)
  String syncStatus;

  TaskHive({
    required this.taskId,
    required this.title,
    required this.createdAt,
     required this.updatedAt,
    required this.authorId,
    this.categoryId,
    this.priority,
    this.status,
    required this.syncStatus 
  });

  factory TaskHive.fromTask(Task task) => TaskHive(
        taskId: task.taskId,
        title: task.title,
        createdAt: task.createdAt,
        updatedAt: task.updatedAt,
        authorId: task.authorId,
        priority: task.priority,
        categoryId: task.categoryId,
        status: task.status.name,
        syncStatus: task.syncStatus.name
      );

  // Convert back to Task
  Task toTask() => Task(
        taskId: taskId,
        title: title,
        createdAt: createdAt,
        updatedAt: updatedAt,
        authorId: authorId,
        priority: priority,
        status: TaskStatusEnum.values.firstWhere(
            (e) => e.name == status,
            orElse: () => TaskStatusEnum.OPEN),
        categoryId: categoryId,
        syncStatus: SyncStatus.values.firstWhere((e)=>e.name == syncStatus, orElse: () => SyncStatus.SYNCED,)
      );
}