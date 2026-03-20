import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:taskflowapp/core/routes/route_extras.dart';
import 'package:taskflowapp/core/theme/app_decorations.dart';
import 'package:taskflowapp/core/theme/app_theme.dart';
import 'package:taskflowapp/core/theme/app_tokens.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';

import '../../domain/entities/task_entity/task_entity.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({required this.task, super.key});

  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColors = AppStatusColors.of(context);
    final statusColor = task.status?.name == 'OPEN'
        ? statusColors.open
        : task.status?.name == 'IN_PROGRESS'
            ? statusColors.inProgress
            : statusColors.done;
    final priorityColor = task.priority == 'HIGH'
        ? statusColors.highPriority
        : task.priority == 'MEDIUM'
            ? statusColors.mediumPriority
            : statusColors.lowPriority;

    return Semantics(
      label: 'Task: ${task.title}. ${task.status?.name.replaceAll('_', ' ')}, ${task.priority ?? ''} priority. Double tap to open.',
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        onTap: () async {
          context.pushNamed(
            'taskDetail',
            pathParameters: {'id': task.taskId},
            extra: TaskDetailExtra(context.read<TasksBloc>()),
          );
        },
        child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: AppDecorations.surfaceCard(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 5,
              height: 65,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: AppTokens.fontWeightSemiBold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTokens.spacingSm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: AppTokens.spacingXs,
                        ),
                        decoration: BoxDecoration(
                          color: priorityColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppTokens.radiusXl),
                        ),
                        child: Text(
                          task.priority ?? '',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: AppTokens.fontSizeXs,
                            fontWeight: AppTokens.fontWeightSemiBold,
                            color: priorityColor,
                          ),
                        ),
                      ),
                      // if (task.syncStatus == SyncStatus.PENDING) ...[
                      //   const SizedBox(width: 6),
                      //   Icon(
                      //     Icons.sync,
                      //     size: 18,
                      //     color: colorScheme.onSurfaceVariant,
                      //   ),
                      // ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      task.status!.name.replaceAll('_', ' '),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: AppTokens.fontWeightMedium,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM yyyy • HH:mm')
                            .format(task.createdAt.toLocal()),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
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
      ),
    );
  }
}