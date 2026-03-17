import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/theme/app_theme.dart';
import 'package:taskflowapp/core/routes/route_extras.dart';
import 'package:taskflowapp/core/utils/snackbar_helper.dart';
import 'package:taskflowapp/features/categories/data/model/category/category.dart';
import 'package:taskflowapp/features/categories/services/category_service.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/task/task_bloc.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/model/task/task.dart';

class TaskDetailsScreen extends StatelessWidget {
  final CategoryService categoryService;
  final String taskId;

  const TaskDetailsScreen({
    super.key,
    required this.taskId,
    required this.categoryService,
  });

  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? '-')),
        ],
      ),
    );
  }

  Future<Category?> getCategoryName({required String categoryId}) async {
    final category = await categoryService.getCategoryDetails(
      categoryId: categoryId,
    );
    if (category != null) {
      return category;
    }
    return null;
  }

  Widget _buildTagRow(
    BuildContext context,
    String label,
    String? value, {
    bool isStatus = false,
    bool isPriority = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColors = Theme.of(context).extension<AppStatusColors>();
    Color? tagColor;
    if (isStatus && value != null && statusColors != null) {
      switch (value.toLowerCase()) {
        case 'open':
          tagColor = statusColors.open;
          break;
        case 'in_progress':
          tagColor = statusColors.inProgress;
          break;
        case 'completed':
          tagColor = statusColors.done;
          break;
        default:
          tagColor = colorScheme.outline;
      }
    } else if (isPriority && value != null && statusColors != null) {
      switch (value.toLowerCase()) {
        case 'high':
          tagColor = statusColors.highPriority;
          break;
        case 'medium':
          tagColor = statusColors.mediumPriority;
          break;
        case 'low':
          tagColor = statusColors.lowPriority;
          break;
        default:
          tagColor = colorScheme.outline;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          if ((isStatus || isPriority) && value != null && tagColor != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: tagColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                value,
                style: TextStyle(color: tagColor, fontWeight: FontWeight.bold),
              ),
            )
          else
            Expanded(
              child: Text(
                value ?? '-',
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: BackButton(color: colorScheme.onPrimary),
        backgroundColor: colorScheme.primary,
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return CircularProgressIndicator(
                    color: colorScheme.onPrimary,
                  );
                }
                return Icon(Icons.delete, color: colorScheme.error);
              },
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      'Delete Task?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => ctx.pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.onSurface,
                        ),
                        child: const Text('No, Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ctx.pop();
                          context.read<TaskBloc>().add(
                            DeleteTask(taskId: taskId),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskFailedState) {
            SnackbarHelper.showErrorMessage(
              context: context,
              message: state.errorMessage,
            );
          } else if (state is TaskDeletionSuccess) {
            SnackbarHelper.showSuccessMessage(context: context, message: "Task deleted");
            context.read<TasksBloc>().add(
              RemoveTaskFromList(taskId: state.taskId),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is TaskFailedState) {
            return Center(child: Text(state.errorMessage));
          } else if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskDetailsSuccess) {
            final task = state.task;
            final colorScheme = Theme.of(context).colorScheme;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Task Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(thickness: 1, height: 16),
                    _buildRow('Title', task.title),
                    const SizedBox(height: 8),
                    _buildTagRow(
                      context,
                      'Priority',
                      task.priority ?? 'LOW',
                      isPriority: true,
                    ),
                    _buildTagRow(context, 'Status', task.status.name, isStatus: true),
                    if (task.categoryId != null)
                      FutureBuilder<Category?>(
                        future: getCategoryName(
                          categoryId: task.categoryId ?? "",
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          } else if (snapshot.hasError) {
                            return const SizedBox();
                          }
                          return _buildRow(
                            'Category',
                            snapshot.data!.categoryName,
                          );
                        },
                      ),
                    const SizedBox(height: 16),

                    Text(
                      'Activity',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    const Divider(thickness: 1, height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: colorScheme.outline,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Created: ${DateFormat('MMM d, yyyy • hh:mm a').format(task.createdAt.toLocal())}',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.update, size: 16, color: colorScheme.outline),
                        const SizedBox(width: 6),
                        Text(
                          'Last Updated: ${DateFormat('MMM d, yyyy • hh:mm a').format(task.updatedAt.toLocal())}',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text(
                            'Update Task',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () async {
                            final Task? updatedTask = await context.pushNamed(
                              'taskForm',
                              extra: EditTaskFormExtra(
                                task,
                                context.read<TaskBloc>(),
                              ),
                            );
                            if (updatedTask != null && context.mounted) {
                              context.read<TasksBloc>().add(
                                UpdateOneTask(task: updatedTask),
                              );
                              context.read<TaskBloc>().add(UpdateToExistingTask(task: updatedTask));
                            } else {
                              if(context.mounted) {
                                context.read<TaskBloc>().add(UpdateToExistingTask(task: task));
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
