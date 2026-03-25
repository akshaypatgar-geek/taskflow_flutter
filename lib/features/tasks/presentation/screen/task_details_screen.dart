import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:taskflowapp/core/utils/constants.dart';
import 'package:taskflowapp/core/utils/enums.dart';
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

import 'package:taskflowapp/core/theme/app_theme.dart';
import 'package:taskflowapp/core/theme/app_tokens.dart';

import '../widgets/detail_row.dart';

/// Task details: drafts and edit mode live in [TaskBloc]. Local [StatefulWidget] state
/// is only for [TextEditingController] / [FocusNode] binding for the title field.
class TaskDetailsScreen extends StatefulWidget {
  final GetCategoryDetailsUseCase getCategoryDetailsUseCase;
  final String taskId;

  const TaskDetailsScreen({
    super.key,
    required this.taskId,
    required this.getCategoryDetailsUseCase,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late final TextEditingController _titleController;
  late final FocusNode _titleFocusNode;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _titleFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _syncTitleControllerFromState(TaskDetailsSuccess s) {
    if (_titleController.text != s.draftTitle) {
      _titleController.text = s.draftTitle;
    }
  }

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
            child: BlocBuilder<TaskBloc, TaskState>(
              buildWhen: (previous, current) {
                if (previous.runtimeType != current.runtimeType) return true;
                if (previous is TaskDetailsSuccess && current is TaskDetailsSuccess) {
                  return previous.isSaving != current.isSaving;
                }
                return false;
              },
              builder: (context, state) {
                if (state is TaskLoading) {
                  return CircularProgressIndicator(
                    color: colorScheme.onPrimary,
                  );
                }
                final disabled = state is TaskDetailsSuccess && state.isSaving;
                return Semantics(
                  label: AppStrings.deleteTask,
                  tooltip: AppStrings.deleteTask,
                  button: true,
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: disabled
                          ? colorScheme.onPrimary.withValues(alpha: 0.38)
                          : colorScheme.error,
                    ),
                    tooltip: AppStrings.deleteTask,
                    onPressed: disabled
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (ctx) => ConfirmDialog(
                                title: AppStrings.deleteTaskQuestion,
                                message: AppStrings.deleteTaskWarning,
                                confirmLabel: 'Delete',
                                cancelLabel: AppStrings.noCancel,
                                isDestructive: true,
                                onConfirm: () {
                                  context.read<TaskBloc>().add(
                                        DeleteTask(taskId: widget.taskId),
                                      );
                                },
                              ),
                            );
                          },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TaskBloc, TaskState>(
            listenWhen: (p, c) =>
                c is TaskFailedState ||
                c is TaskDeletionSuccess ||
                (c is TaskDetailsSuccess && c.saveFailureMessage != null),
            listener: (context, state) {
              if (state is TaskFailedState) {
                SnackbarHelper.showErrorMessage(
                  context: context,
                  message: state.errorMessage,
                );
                return;
              }
              if (state is TaskDeletionSuccess) {
                SnackbarHelper.showSuccessMessage(
                  context: context,
                  message: AppStrings.taskDeleted,
                );
                context.read<TasksBloc>().add(
                  RemoveTaskFromList(taskId: state.taskId),
                );
                if (context.canPop()) {
                  context.pop();
                }
                return;
              }
              if (state is TaskDetailsSuccess && state.saveFailureMessage != null) {
                SnackbarHelper.showErrorMessage(
                  context: context,
                  message: state.saveFailureMessage!,
                );
                context.read<TaskBloc>().add(ClearTaskSaveFeedback());
              }
            },
          ),
          BlocListener<TaskBloc, TaskState>(
            listenWhen: (p, c) {
              if (c is! TaskDetailsSuccess) return false;
              if (p is! TaskDetailsSuccess) return true;
              if (p.isEditingTitle != c.isEditingTitle) return true;
              if (p.isSaving && !c.isSaving && c.saveFailureMessage == null) return true;
              return false;
            },
            listener: (context, state) {
              if (state is! TaskDetailsSuccess) return;
              _syncTitleControllerFromState(state);
              if (state.isEditingTitle) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    _titleFocusNode.requestFocus();
                  }
                });
              }
            },
          ),
          BlocListener<TaskBloc, TaskState>(
            listenWhen: (p, c) =>
                p is TaskDetailsSuccess &&
                p.isSaving &&
                c is TaskDetailsSuccess &&
                !c.isSaving &&
                c.saveFailureMessage == null,
            listener: (context, state) {
              final s = state as TaskDetailsSuccess;
              _syncTitleControllerFromState(s);
              context.read<TasksBloc>().add(UpdateOneTask(task: s.task));
              SnackbarHelper.showSuccessMessage(
                context: context,
                message: AppStrings.taskDetailsUpdated,
              );
            },
          ),
        ],
        child: BlocBuilder<TaskBloc, TaskState>(
          buildWhen: (previous, current) {
            if (current is TaskFailedState) return true;
            if (current is TaskLoading) return true;
            if (current is TaskDetailsSuccess) {
              if (previous is! TaskDetailsSuccess) return true;
              return previous.task != current.task ||
                  previous.isSaving != current.isSaving ||
                  previous.saveFailureMessage != current.saveFailureMessage ||
                  previous.draftTitle != current.draftTitle ||
                  previous.draftPriority != current.draftPriority ||
                  previous.draftStatus != current.draftStatus ||
                  previous.isEditingTitle != current.isEditingTitle ||
                  previous.titleFieldError != current.titleFieldError;
            }
            return false;
          },
          builder: (context, state) {
            if (state is TaskFailedState) {
              return Center(child: Text(state.errorMessage));
            }
            if (state is TaskLoading) {
              return const AppLoadingIndicator();
            }
            if (state is TaskDetailsSuccess) {
              final task = state.task;
              final isSaving = state.isSaving;
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
                        _TitleRow(
                          state: state,
                          titleController: _titleController,
                          titleFocusNode: _titleFocusNode,
                          isSaving: isSaving,
                        ),
                        const SizedBox(height: AppTokens.sM),
                        _TaskDetailChipSection(
                          title: AppStrings.priorityLabel,
                          child: _InteractivePriorityChips(
                            selectedPriority: state.draftPriority,
                            onPrioritySelected: isSaving
                                ? null
                                : (p) => context.read<TaskBloc>().add(
                                      TaskDetailsDraftPriorityChanged(p),
                                    ),
                          ),
                        ),
                        const SizedBox(height: AppTokens.sL),
                        _TaskDetailChipSection(
                          title: AppStrings.statusLabel,
                          child: _InteractiveStatusChips(
                            selectedStatus: state.draftStatus,
                            onStatusSelected: isSaving
                                ? null
                                : (s) => context.read<TaskBloc>().add(
                                      TaskDetailsDraftStatusChanged(s),
                                    ),
                          ),
                        ),
                        if (task.categoryId != null)
                          _CategoryNameRow(
                            categoryId: task.categoryId!,
                            getCategoryDetailsUseCase: widget.getCategoryDetailsUseCase,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: AppTokens.s / 2),
                              child: Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: colorScheme.outline,
                              ),
                            ),
                            const SizedBox(width: AppTokens.r),
                            Expanded(
                              child: Text(
                                '${AppStrings.createdPrefix}${DateFormat('MMM d, yyyy • hh:mm a').format(task.createdAt.toLocal())}',
                                softWrap: true,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTokens.sM),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: AppTokens.s / 2),
                              child: Icon(Icons.update, size: 16, color: colorScheme.outline),
                            ),
                            const SizedBox(width: AppTokens.r),
                            Expanded(
                              child: Text(
                                '${AppStrings.lastUpdatedPrefix}${DateFormat('MMM d, yyyy • hh:mm a').format(task.updatedAt.toLocal())}',
                                softWrap: true,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTokens.sXxxl),
                        if (state.showInlineUpdateButton)
                          Semantics(
                            label: AppStrings.updateTask,
                            tooltip: AppStrings.updateTaskTooltip,
                            button: true,
                            child: PrimaryButton(
                              label: AppStrings.updateTask,
                              isLoading: isSaving,
                              onPressed: isSaving
                                  ? null
                                  : () => context.read<TaskBloc>().add(TaskDetailsSubmitInline()),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const Center(
              child: Text(AppStrings.somethingWentWrong),
            );
          },
        ),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({
    required this.state,
    required this.titleController,
    required this.titleFocusNode,
    required this.isSaving,
  });

  final TaskDetailsSuccess state;
  final TextEditingController titleController;
  final FocusNode titleFocusNode;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bloc = context.read<TaskBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.titleLabel,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: AppTokens.sM),
        if (!state.isEditingTitle)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  state.task.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Semantics(
                label: AppStrings.editTitle,
                tooltip: AppStrings.editTitle,
                button: true,
                child: IconButton(
                  icon: Icon(Icons.edit_outlined, color: colorScheme.primary),
                  tooltip: AppStrings.editTitle,
                  onPressed: isSaving
                      ? null
                      : () => bloc.add(TaskDetailsTitleEditingChanged(true)),
                ),
              ),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: titleController,
                  focusNode: titleFocusNode,
                  maxLength: AppStrings.taskTitleMaxLength,
                  maxLines: 2,
                  enabled: !isSaving,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(AppStrings.taskTitleMaxLength),
                  ],
                  decoration: InputDecoration(
                    labelText: AppStrings.titleLabel,
                    errorText: state.titleFieldError,
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTokens.rM),
                    ),
                  ),
                  onChanged: (v) => bloc.add(TaskDetailsDraftTitleChanged(v)),
                ),
              ),
              Semantics(
                label: AppStrings.cancel,
                tooltip: AppStrings.cancel,
                button: true,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: AppStrings.cancel,
                  onPressed: isSaving
                      ? null
                      : () => bloc.add(TaskDetailsTitleEditingChanged(false)),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

/// Fetches and displays category name once per [categoryId].
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
          return const DetailRow(label: AppStrings.categoryLabel,
          value: '...',);
        }
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }
        return DetailRow(
          label: AppStrings.categoryLabel,
          value: snapshot.data?.categoryName,
        );
      },
    );
  }
}

class _TaskDetailChipSection extends StatelessWidget {
  const _TaskDetailChipSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: AppTokens.sM),
        SizedBox(width: double.infinity, child: child),
      ],
    );
  }
}

class _InteractivePriorityChips extends StatelessWidget {
  const _InteractivePriorityChips({
    required this.selectedPriority,
    this.onPrioritySelected,
  });

  final String selectedPriority;
  final ValueChanged<String>? onPrioritySelected;

  static const _priorities = <String>['LOW', 'MEDIUM', 'HIGH'];

  static String _label(String p) =>
      p.isEmpty ? p : '${p[0]}${p.substring(1).toLowerCase()}';

  static Color _accent(String p, AppStatusColors colors) {
    switch (p) {
      case 'HIGH':
        return colors.highPriority;
      case 'MEDIUM':
        return colors.mediumPriority;
      case 'LOW':
      default:
        return colors.lowPriority;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppStatusColors.of(context);
    final current = selectedPriority.toUpperCase();
    return Wrap(
      spacing: AppTokens.sM,
      runSpacing: AppTokens.sM,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final p in _priorities)
          _TaskDetailAccentChip(
            label: _label(p),
            accent: _accent(p, colors),
            selected: current == p,
            onTap: onPrioritySelected == null ? null : () => onPrioritySelected!(p),
          ),
      ],
    );
  }
}

class _InteractiveStatusChips extends StatelessWidget {
  const _InteractiveStatusChips({
    required this.selectedStatus,
    this.onStatusSelected,
  });

  final TaskStatusEnum selectedStatus;
  final ValueChanged<TaskStatusEnum>? onStatusSelected;

  static String _label(TaskStatusEnum e) {
    switch (e) {
      case TaskStatusEnum.OPEN:
        return AppStrings.open;
      case TaskStatusEnum.IN_PROGRESS:
        return AppStrings.inProgress;
      case TaskStatusEnum.COMPLETED:
        return AppStrings.completed;
    }
  }

  static Color _accent(TaskStatusEnum e, AppStatusColors colors) {
    switch (e) {
      case TaskStatusEnum.OPEN:
        return colors.open;
      case TaskStatusEnum.IN_PROGRESS:
        return colors.inProgress;
      case TaskStatusEnum.COMPLETED:
        return colors.done;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppStatusColors.of(context);
    return Wrap(
      spacing: AppTokens.sM,
      runSpacing: AppTokens.sM,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final s in TaskStatusEnum.values)
          _TaskDetailAccentChip(
            label: _label(s),
            accent: _accent(s, colors),
            selected: selectedStatus == s,
            onTap: onStatusSelected == null ? null : () => onStatusSelected!(s),
          ),
      ],
    );
  }
}

class _TaskDetailAccentChip extends StatelessWidget {
  const _TaskDetailAccentChip({
    required this.label,
    required this.selected,
    required this.accent,
    this.onTap,
  });

  final String label;
  final bool selected;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final onAccent = ThemeData.estimateBrightnessForColor(accent) == Brightness.dark
        ? Colors.white
        : const Color(0xFF212121);
    final interactive = onTap != null;

    final child = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.sL,
        vertical: AppTokens.s,
      ),
      decoration: BoxDecoration(
        color: selected ? accent : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTokens.rXl),
        border: Border.all(
          color: selected ? accent : colorScheme.outline.withValues(alpha: 0.45),
          width: selected ? 2 : 1,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected ? onAccent : colorScheme.onSurface,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
      ),
    );

    return Semantics(
      selected: selected,
      label: label,
      button: interactive,
      enabled: interactive,
      child: interactive
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(AppTokens.rXl),
                child: child,
              ),
            )
          : child,
    );
  }
}
