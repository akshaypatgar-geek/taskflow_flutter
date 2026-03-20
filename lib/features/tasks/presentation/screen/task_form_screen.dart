import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/utils/constants.dart';
import 'package:taskflowapp/core/utils/snackbar_helper.dart';
import 'package:taskflowapp/core/widgets/primary_button.dart';
import 'package:taskflowapp/core/widgets/surface_card.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/enums.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/domain/usecases/list_categories_use_case.dart';
import '../../domain/entities/task_entity/task_entity.dart';
import '../bloc/task/task_bloc.dart';

class TaskFormWidget extends StatefulWidget {
  final TaskEntity? task;
  final ListCategoriesUseCase listCategoriesUseCase;

  const TaskFormWidget({super.key, this.task, required this.listCategoriesUseCase});

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TextEditingController _titleController;
  String? _selectedPriority;
  String? _selectedCategory;
  TaskStatusEnum _status = TaskStatusEnum.OPEN;
  Future<List<CategoryEntity>>? _categoriesFuture;
   final _formKey = GlobalKey<FormState>();
  

  final List<String> priorities = ['LOW', 'MEDIUM', 'HIGH'];

  @override
  void initState() {
    super.initState();
    _categoriesFuture = widget.listCategoriesUseCase().then(
      (result) => result.fold((_) => <CategoryEntity>[], (r) => r),
    );
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _selectedPriority = widget.task?.priority ?? priorities[0];
    _selectedCategory = widget.task?.categoryId;
    _status = widget.task?.status ?? TaskStatusEnum.OPEN;
  }


  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if(!_formKey.currentState!.validate()) {
      SnackbarHelper.showErrorMessage(context: context, message: AppStrings.titleCannotBeEmpty);
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
      context.read<TaskBloc>().add(UpdateTaskEvent(taskId: widget.task!.taskId,
      title: _titleController.text.trim(),
      priority: _selectedPriority,
      status: _status.name
       ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: Semantics(
          label: 'Back',
          child: BackButton(color: colorScheme.onPrimary),
        ),
        backgroundColor: colorScheme.primary,
        title: Text(widget.task == null ? 'Create Task' : 'Update Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SurfaceCard(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if(value==null || value.trim()=='') {
                      return AppStrings.titleRequired;
                    }
                    return null;
                  },
                ),
            const SizedBox(height: 16),
        
            
            DropdownButtonFormField<String>(
              initialValue: _selectedPriority,
              items: priorities
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedPriority = val),
              decoration: const InputDecoration(
                labelText: 'Priority',
              ),
            ),
            const SizedBox(height: 16),
            if (widget.task == null)
              FutureBuilder<List<CategoryEntity>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final categories = snapshot.data ?? [];
                  return DropdownButtonFormField<String>(
                   
                    items: categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.categoryId.toString(),
                            child: Text(c.categoryName),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val),
                    decoration: const InputDecoration(
                      labelText: 'Category',
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
        
            
            if (widget.task != null)
              DropdownButtonFormField<TaskStatusEnum>(
                initialValue: _status,
                items: TaskStatusEnum.values
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _status = val);
                },
                decoration: const InputDecoration(
                  labelText: 'Status',
                ),
              ),
                const SizedBox(height: 24),
                BlocConsumer<TaskBloc, TaskState>(
                  listener: (context, state) {
                    if (state is TaskCreationSuccess) {
                      SnackbarHelper.showSuccessMessage(
                        context: context,
                        message: AppStrings.taskCreated(state.task.title),
                      );
                      context.read<TasksBloc>().add(AddTaskToList(task: state.task));
                      context.pop();
                    } else if (state is TaskUpdateSuccess) {
                      SnackbarHelper.showSuccessMessage(
                        context: context,
                        message: AppStrings.taskDetailsUpdated,
                      );
                      context.pop(state.task);
                    }
                  },
                  builder: (context, state) {
                    return PrimaryButton(
                      label: widget.task == null ? 'Create Task' : 'Update Task',
                      isLoading: state is TaskLoading,
                      onPressed: _handleSubmit,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
