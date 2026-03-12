import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/utils/enums.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';

import '../../data/model/task/task.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
     return InkWell(
  borderRadius: BorderRadius.circular(16),
  onTap: () async {
    context.pushNamed(
      'taskDetail',
      pathParameters: {"id": task.taskId},
      extra: context.read<TasksBloc>(),
    );
  },
  child: Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:  0.05),
          blurRadius: 10,
          offset: const Offset(0, 5),
        )
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// STATUS INDICATOR
        Container(
          width: 5,
          height: 65,
          decoration: BoxDecoration(
            color: task.status.name == "OPEN"
                ? Colors.blue
                : task.status.name == "IN_PROGRESS"
                    ? Colors.orange
                    : Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        const SizedBox(width: 14),

        /// TASK CONTENT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TITLE + PRIORITY
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// PRIORITY CHIP
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: task.priority == "HIGH"
                          ? Colors.red.shade50
                          : task.priority == "MEDIUM"
                              ? Colors.orange.shade50
                              : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      task.priority ?? "",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: task.priority == "HIGH"
                            ? Colors.red.shade700
                            : task.priority == "MEDIUM"
                                ? Colors.orange.shade800
                                : Colors.green.shade700,
                      ),
                    ),
                  ),

                  if (task.syncStatus == SyncStatus.PENDING) ...[
                    const SizedBox(width: 6),
                    Icon(
                      Icons.sync,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                  ]
                ],
              ),

              const SizedBox(height: 6),

              /// STATUS CHIP
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: task.status.name == "OPEN"
                      ? Colors.blue.shade50
                      : task.status.name == "IN_PROGRESS"
                          ? Colors.orange.shade50
                          : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  task.status.name.replaceAll("_", " "),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: task.status.name == "OPEN"
                        ? Colors.blue
                        : task.status.name == "IN_PROGRESS"
                            ? Colors.orange.shade800
                            : Colors.green.shade700,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// CREATED DATE
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd MMM yyyy • HH:mm')
                        .format(task.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);
  }
}