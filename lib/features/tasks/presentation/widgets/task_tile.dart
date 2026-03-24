import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:taskflowapp/core/routes/router.dart';
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
        borderRadius: BorderRadius.circular(AppTokens.rL),
        onTap: () async {
          context.pushNamed(
            ScreenPaths.taskDetail.name,
            pathParameters: {'id': task.taskId},
            extra: TaskDetailExtra(context.read<TasksBloc>()),
          );
        },
        child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppTokens.r),
        padding: const EdgeInsets.all(AppTokens.sXl),
        decoration: AppDecorations.surfaceCard(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Container(
                width: 5,
                height: 65,
                decoration: AppDecorations.accentBar(color: statusColor, radius: AppTokens.rM),
              ),
            ),
            const SizedBox(width: AppTokens.sL),
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
                      const SizedBox(width: AppTokens.sM),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: AppTokens.s,
                        ),
                        decoration: AppDecorations.softBadge(
                          color: priorityColor,
                          radius: AppTokens.rXl,
                        ),
                        child: Text(
                          task.priority ?? '',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: AppTokens.f,
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
                  const SizedBox(height: AppTokens.r),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: AppDecorations.softBadge(
                      color: statusColor,
                      radius: AppTokens.r,
                    ),
                    child: Text(
                      task.status!.name.replaceAll('_', ' '),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: AppTokens.fontWeightMedium,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTokens.sM),
                  Row(
                    children: [
                      ExcludeSemantics(
                        child: Icon(
                          Icons.schedule,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: AppTokens.s),
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