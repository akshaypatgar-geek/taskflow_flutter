// import 'package:equatable/equatable.dart';
// import 'package:taskflowapp/core/utils/enums.dart';


// class TaskEntity extends Equatable {
//   const TaskEntity({
//     required this.taskId,
//     required this.title,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.authorId,
//     this.priority,
//     this.categoryId,
//     this.status = TaskStatusEnum.OPEN,
//     this.syncStatus = SyncStatus.SYNCED,
//   });

//   final String taskId;
//   final String title;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final String authorId;
//   final String? priority;
//   final String? categoryId;
//   final TaskStatusEnum status;
//   final SyncStatus syncStatus;

//   TaskEntity copyWith({
//     String? taskId,
//     String? title,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     String? authorId,
//     String? priority,
//     String? categoryId,
//     TaskStatusEnum? status,
//     SyncStatus? syncStatus,
//   }) {
//     return TaskEntity(
//       taskId: taskId ?? this.taskId,
//       title: title ?? this.title,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       authorId: authorId ?? this.authorId,
//       priority: priority ?? this.priority,
//       categoryId: categoryId ?? this.categoryId,
//       status: status ?? this.status,
//       syncStatus: syncStatus ?? this.syncStatus,
//     );
//   }

//   @override
//   List<Object?> get props => [taskId, title, createdAt, updatedAt, authorId, priority, categoryId, status, syncStatus];
// }
