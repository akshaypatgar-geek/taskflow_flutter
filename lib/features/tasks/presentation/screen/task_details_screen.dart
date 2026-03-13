import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
    String label,
    String? value, {
    bool isStatus = false,
    bool isPriority = false,
  }) {
    Color? tagColor;
    print("value here:$label $value");
    if (isStatus && value != null) {
      switch (value.toLowerCase()) {
        case 'open':
          tagColor = Colors.blue;
          break;
        case 'in_progress':
          tagColor = Colors.orange;
          break;
        case 'completed':
          tagColor = Colors.green;
          break;
        default:
          tagColor = Colors.grey;
      }
    } else if (isPriority && value != null) {
      switch (value.toLowerCase()) {
        case 'high':
          tagColor = Colors.redAccent;
          break;
        case 'medium':
          tagColor = Colors.orangeAccent;
          break;
        case 'low':
          tagColor = Colors.green;
          break;
        default:
          tagColor = Colors.grey;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          if ((isStatus || isPriority) && value != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: tagColor!.withValues(alpha: 0.2),
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
                style: const TextStyle(color: Colors.black87),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: BackButton(color: Colors.white54),
        backgroundColor: Colors.grey.shade900,
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const CircularProgressIndicator.adaptive();
                }
                return const Icon(Icons.delete, color: Colors.red);
              },
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text(
                      "Delete Task?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => ctx.pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade900,
                        ),
                        child: const Text("No, Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ctx.pop();
                          context.read<TaskBloc>().add(
                            DeleteTask(taskId: taskId),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade900,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          "Delete",
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
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Task Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Divider(thickness: 1, height: 16),
                    _buildRow('Title', task.title),
                    const SizedBox(height: 8),
                    _buildTagRow(
                      'Priority',
                      task.priority ?? "LOW",
                      isPriority: true,
                    ),
                    _buildTagRow('Status', task.status.name, isStatus: true),
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
                      "Activity",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const Divider(thickness: 1, height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Created: ${DateFormat('MMM d, yyyy • hh:mm a').format(task.createdAt.toLocal())}',
                          style: TextStyle(color: Colors.grey.shade800),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.update, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          'Last Updated: ${DateFormat('MMM d, yyyy • hh:mm a').format(task.updatedAt.toLocal())}',
                          style: TextStyle(color: Colors.grey.shade800),
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
                            backgroundColor: Colors.grey.shade900,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () async {
                            final Task? updatedTask = await context.pushNamed(
                              'taskForm',
                              extra: {
                                'task': task,
                                'bloc': context.read<TaskBloc>(),
                              },
                            );
                            if (updatedTask != null && context.mounted) {
                              context.read<TasksBloc>().add(
                                UpdateOneTask(task: updatedTask),
                              );
                              context.read<TaskBloc>().emit(
                                TaskDetailsSuccess(task: updatedTask),
                              );
                            } else {
                              context.read<TaskBloc>().emit(
                                TaskDetailsSuccess(task: task),
                              );
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
