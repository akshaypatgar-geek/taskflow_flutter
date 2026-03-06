import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';

import '../../data/model/task/task.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
       context.pushNamed('taskDetail',
        pathParameters: {
          "id":task.taskId
        },
        extra: context.read<TasksBloc>());
        

      },
      child: Container(
  margin: const EdgeInsets.symmetric(vertical: 8,),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.grey[100],
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey[300]!),
  ),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      // Status indicator bar
      Container(
        width: 6,
        height: 60,
        decoration: BoxDecoration(
          color: task.status.name == "OPEN"
              ? Colors.blue
              : task.status.name == "IN_PROGRESS"
                  ? Colors.orange
                  : Colors.green,
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      const SizedBox(width: 16),

      // Task content
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Title + Priority
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Priority badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: task.priority == "HIGH"
                        ? Colors.red[50]
                        : task.priority == "MEDIUM"
                            ? Colors.orange[50]
                            : Colors.green[50],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: task.priority == "HIGH"
                          ? Colors.red
                          : task.priority == "MEDIUM"
                              ? Colors.orange
                              : Colors.green,
                    ),
                  ),
                  child: Text(
                    task.priority??"",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: task.priority == "HIGH"
                          ? Colors.red[700]
                          : task.priority == "MEDIUM"
                              ? Colors.orange[800]
                              : Colors.green[700],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Status
            Text(
              task.status.name.replaceAll("_", " "),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: task.status.name == "OPEN"
                    ? Colors.blue
                    : task.status.name == "IN_PROGRESS"
                        ? Colors.orange[800]
                        : Colors.green[700],
              ),
            ),

            const SizedBox(height: 4),

            // Created time
            Text(
              DateFormat('dd MMM yyyy • HH:mm').format(task.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    ],
  ),
)
    );
  }
}