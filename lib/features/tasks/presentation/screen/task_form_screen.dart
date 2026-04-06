import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/utils/constants.dart';
import 'package:taskflowapp/core/utils/snackbar_helper.dart';
import 'package:taskflowapp/core/widgets/primary_button.dart';
import 'package:taskflowapp/core/widgets/responsive_container.dart';
import 'package:taskflowapp/core/widgets/surface_card.dart';
import 'package:taskflowapp/core/widgets/network_aware_app_bar.dart';
import 'package:taskflowapp/features/categories/domain/entities/category_entity.dart';
import 'package:taskflowapp/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/enums.dart';
import '../../domain/entities/task_entity/task_entity.dart';
import '../bloc/task/task_bloc.dart';
import 'package:taskflowapp/core/theme/app_tokens.dart';

class TaskFormWidget extends StatefulWidget {
  final TaskEntity? task;

  const TaskFormWidget({
    super.key,
    this.task,
  });

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  final TextEditingController _titleController = TextEditingController();
  String? _selectedPriority;
  String? _selectedCategory;
  TaskStatusEnum _status = TaskStatusEnum.OPEN;
  final _formKey = GlobalKey<FormState>();

  final List<String> priorities = ['LOW', 'MEDIUM', 'HIGH'];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task?.title ?? '';
    _selectedPriority = widget.task?.priority ?? priorities[0];
    _selectedCategory = widget.task?.categoryId;
    _status = widget.task?.status ?? TaskStatusEnum.OPEN;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.task == null) {
        context.read<CategoriesBloc>().add(LoadCategories());
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      SnackbarHelper.showErrorMessage(
        context: context,
        message: AppStrings.titleCannotBeEmpty,
      );
      return;
    }
    if (widget.task == null) {
      context.read<TaskBloc>().add(
        CreateTaskEvent(
          taskId: Uuid().v4(),
          title: _titleController.text.trim(),
          categoryId: _selectedCategory,
          priority: _selectedPriority,
        ),
      );
    } else {
      context.read<TaskBloc>().add(
        UpdateTaskEvent(
          taskId: widget.task!.taskId,
          title: _titleController.text.trim(),
          priority: _selectedPriority,
          status: _status.name,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: NetworkAwareAppBar.of(
        context,
        leading: Semantics(
          label: AppStrings.back,
          child: BackButton(),
        ),
        title: Text(
          widget.task == null ? AppStrings.createTask : AppStrings.updateTask,
        ),
      ),
      body: ResponsiveContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: AppTokens.sXl),
          child: SurfaceCard(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.titleLabel,
                    ),
                    validator: (value) {
                      if (value == null || value.trim() == '') {
                        return AppStrings.titleRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppTokens.sXl),

                  DropdownButtonFormField<String>(
                    initialValue: _selectedPriority,
                    items: priorities
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedPriority = val),
                    decoration: const InputDecoration(
                      labelText: AppStrings.priorityLabel,
                    ),
                  ),
                  const SizedBox(height: AppTokens.sXl),
                  if (widget.task == null)
                    BlocBuilder<CategoriesBloc, CategoriesState>(
                      builder: (context, catState) {
                        final categories = switch (catState) {
                          CategoriesLoaded(:final categories) => categories,
                          CategoriesCreating(:final categories) => categories,
                          CategoriesFailed(:final categories) =>
                            categories ?? const <CategoryEntity>[],
                          _ => const <CategoryEntity>[],
                        };
                        final loading = catState is CategoriesInitial ||
                            catState is CategoriesLoading ||
                            (catState is CategoriesCreating &&
                                categories.isEmpty);
                        if (loading && categories.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(AppTokens.sXxxl),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (catState is CategoriesFailed &&
                            categories.isEmpty) {
                          return Text(
                            catState.errorMessage,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          );
                        }
                        final categoryIds = categories
                            .map((c) => c.categoryId.toString())
                            .toSet();
                        final safeValue = _selectedCategory != null &&
                                categoryIds.contains(_selectedCategory)
                            ? _selectedCategory
                            : null;
                        return DropdownButtonFormField<String>(
                          value: safeValue,
                          items: categories
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c.categoryId.toString(),
                                  child: Text(c.categoryName),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedCategory = val),
                          decoration: const InputDecoration(
                            labelText: AppStrings.categoryLabel,
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: AppTokens.sXl),

                  if (widget.task != null)
                    DropdownButtonFormField<TaskStatusEnum>(
                      initialValue: _status,
                      items: TaskStatusEnum.values
                          .map(
                            (e) =>
                                DropdownMenuItem(value: e, child: Text(e.name)),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _status = val);
                      },
                      decoration: const InputDecoration(
                        labelText: AppStrings.statusLabel,
                      ),
                    ),
                  const SizedBox(height: AppTokens.sXxxl),
                  BlocConsumer<TaskBloc, TaskState>(
                    listener: (context, state) {
                      if (state is TaskCreationSuccess) {
                        SnackbarHelper.showSuccessMessage(
                          context: context,
                          message: AppStrings.taskCreated(state.task.title),
                        );
                        context.read<TasksBloc>().add(
                          AddTaskToList(task: state.task),
                        );
                        context.pop();
                      } else if (state is TaskUpdateSuccess) {
                        SnackbarHelper.showSuccessMessage(
                          context: context,
                          message: AppStrings.taskDetailsUpdated,
                        );
                        context.pop(state.task);
                      }
                    },
                    buildWhen: (previous, current) {
                      if (previous.runtimeType != current.runtimeType) {
                        return true;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      return Semantics(
                        label: widget.task == null
                            ? AppStrings.createTask
                            : AppStrings.updateTask,
                        tooltip: widget.task == null
                            ? AppStrings.createTask
                            : AppStrings.updateTask,
                        button: true,
                        child: PrimaryButton(
                          label: widget.task == null
                              ? AppStrings.createTask
                              : AppStrings.updateTask,
                          isLoading: state is TaskLoading,
                          onPressed: _handleSubmit,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
