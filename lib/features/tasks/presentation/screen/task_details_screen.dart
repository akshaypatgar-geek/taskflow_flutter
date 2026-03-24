import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:taskflowapp/core/routes/router.dart';
import 'package:taskflowapp/core/routes/route_extras.dart';
import 'package:taskflowapp/core/utils/constants.dart';
import 'package:taskflowapp/core/utils/snackbar_helper.dart';
import 'package:taskflowapp/core/widgets/app_loading_indicator.dart';
import 'package:taskflowapp/core/widgets/confirm_dialog.dart';
import 'package:taskflowapp/core/widgets/primary_button.dart';
import 'package:taskflowapp/core/widgets/responsive_container.dart';
import 'package:taskflowapp/core/widgets/surface_card.dart';
import 'package:taskflowapp/features/categories/domain/entities/category_entity.dart';
import 'package:taskflowapp/features/categories/domain/usecases/get_category_details_use_case.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/task/task_bloc.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';

import '../../domain/entities/task_entity/task_entity.dart';
import '../widgets/detail_row.dart';
import '../widgets/status_priority_tag.dart';
import 'package:taskflowapp/core/theme/app_tokens.dart';

class TaskDetailsScreen extends StatelessWidget {
  final GetCategoryDetailsUseCase getCategoryDetailsUseCase;
  final String taskId;

  const TaskDetailsScreen({
    super.key,
    required this.taskId,
    required this.getCategoryDetailsUseCase,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: Semantics(
          label: AppStrings.back,
          child: BackButton(color: colorScheme.onPrimary),
        ),
        backgroundColor: colorScheme.primary,
        title: const Text(AppStrings.taskDetailsTitle),
        actions: [
          Semantics(
            label: AppStrings.deleteTask,
            tooltip: AppStrings.deleteTask,
            button: true,
            child: IconButton(
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
              tooltip: AppStrings.deleteTask,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => ConfirmDialog(
                    title: AppStrings.deleteTaskQuestion,
                    message: AppStrings.deleteTaskWarning,
                    confirmLabel: 'Delete',
                    cancelLabel: AppStrings.noCancel,
                    isDestructive: true,
                    onConfirm: () {
                      context.read<TaskBloc>().add(DeleteTask(taskId: taskId));
                    },
                  ),
                );
              },
            ),
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
            SnackbarHelper.showSuccessMessage(context: context, message: AppStrings.taskDeleted);
            context.read<TasksBloc>().add(
              RemoveTaskFromList(taskId: state.taskId),
            );
            if(context.canPop()) {
              context.pop();
            }
          }
        },
        buildWhen: (previous, current) {
          if (previous.runtimeType != current.runtimeType) {
      return true;
    }
    if(previous is TaskDetailsSuccess && current is TaskDetailsSuccess) {
      return previous.task.updatedAt != current.task.updatedAt;
    }
    return false;
        },
        builder: (context, state) {
          if (state is TaskFailedState) {
            return Center(child: Text(state.errorMessage));
          } else           if (state is TaskLoading) {
            return const AppLoadingIndicator();
          } else if (state is TaskDetailsSuccess) {
            final task = state.task;
            final colorScheme = Theme.of(context).colorScheme;
            return ResponsiveContainer(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: AppTokens.sXl),
                child: SurfaceCard(
                  padding: const EdgeInsets.all(AppTokens.sXxxl),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.taskDetailsTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(thickness: 1, height: 16),
                    DetailRow(label: AppStrings.titleLabel, value: task.title),
                    const SizedBox(height: AppTokens.sM),
                    StatusPriorityTag(
                      label: AppStrings.priorityLabel,
                      value: task.priority ?? 'LOW',
                      isPriority: true,
                    ),
                    StatusPriorityTag(
                      label: AppStrings.statusLabel,
                      value: task.status?.name,
                      isStatus: true,
                    ),
                    if (task.categoryId != null)
                      _CategoryNameRow(
                        categoryId: task.categoryId!,
                        getCategoryDetailsUseCase: getCategoryDetailsUseCase,
                      ),
                    const SizedBox(height: AppTokens.sXl),
                    Text(
                      AppStrings.activityTitle,
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
                        const SizedBox(width: AppTokens.r),
                        Text(
                          'Created: ${DateFormat('MMM d, yyyy • hh:mm a').format(task.createdAt.toLocal())}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTokens.sM),
                    Row(
                      children: [
                        Icon(Icons.update, size: 16, color: colorScheme.outline),
                        const SizedBox(width: AppTokens.r),
                        Text(
                          'Last Updated: ${DateFormat('MMM d, yyyy • hh:mm a').format(task.updatedAt.toLocal())}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTokens.sXxxl),
                    Semantics(
                      label: AppStrings.updateTask,
                      tooltip: AppStrings.updateTaskTooltip,
                      button: true,
                      child: PrimaryButton(
                        label: AppStrings.updateTask,
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final TaskEntity? updatedTask = await context.pushNamed(
                            ScreenPaths.taskForm.name,
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
                          } else if (context.mounted) {
                            context.read<TaskBloc>().add(UpdateToExistingTask(task: task));
                          }
                        },
                      ),
                    ),
                  ],
                  ),
                ),
              ),
            );
          }
          return const AppLoadingIndicator();
        },
      ),
    );
  }
}

/// Fetches and displays category name once per [categoryId].
/// Caches the Future in state to avoid API calls on every parent rebuild.
class _CategoryNameRow extends StatefulWidget {
  final String categoryId;
  final GetCategoryDetailsUseCase getCategoryDetailsUseCase;

  const _CategoryNameRow({
    required this.categoryId,
    required this.getCategoryDetailsUseCase,
  });

  @override
  State<_CategoryNameRow> createState() => _CategoryNameRowState();
}

class _CategoryNameRowState extends State<_CategoryNameRow> {
  Future<CategoryEntity?>? _categoryFuture;

  @override
  void initState() {
    super.initState();
    _categoryFuture = _fetchCategory();
  }

  Future<CategoryEntity?> _fetchCategory() async {
    final result = await widget.getCategoryDetailsUseCase(widget.categoryId);
    return result.fold((_) => null, (r) => r);
  }

  @override
  void didUpdateWidget(_CategoryNameRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryId != widget.categoryId) {
      setState(() => _categoryFuture = _fetchCategory());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CategoryEntity?>(
      future: _categoryFuture!,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }
        if (snapshot.hasError) {
          return const SizedBox();
        }
        return DetailRow(
          label: AppStrings.categoryLabel,
          value: snapshot.data?.categoryName,
        );
      },
    );
  }
}
