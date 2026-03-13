import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/enums.dart';
import '../../../categories/data/model/category/category.dart';
import '../../../categories/services/category_service.dart';
import '../../data/model/task/task.dart';
import '../bloc/task/task_bloc.dart';

class TaskFormWidget extends StatefulWidget {
  final Task? task;
  final CategoryService categoryService;

  const TaskFormWidget({super.key, this.task, required this.categoryService});

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TextEditingController _titleController;
  String? _selectedPriority;
  String? _selectedCategory;
  TaskStatusEnum _status = TaskStatusEnum.OPEN;
   Future<List<Category>>? _categoriesFuture;
  

  final List<String> priorities = ['LOW', 'MEDIUM', 'HIGH'];

  @override
  void initState() {
    super.initState();
    _categoriesFuture = widget.categoryService.listCategories().then((cat)=>cat??[]);
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
    return Scaffold(
  backgroundColor: Colors.grey.shade100,
  appBar: AppBar(
    leading: BackButton(color: Colors.white54),
    backgroundColor: Colors.grey.shade900,
    title: Text(widget.task == null ? "Create Task" : "Update Task"),
  ),
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Container(
      padding: const EdgeInsets.all(20),
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
        children: [
        
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          
          DropdownButtonFormField<String>(
            initialValue: _selectedPriority,
            items: priorities
                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                .toList(),
            onChanged: (val) => setState(() => _selectedPriority = val),
            decoration: InputDecoration(
              labelText: 'Priority',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          
          if (widget.task == null)
            FutureBuilder<List<Category>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          const SizedBox(height: 24),

          
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade900,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: BlocConsumer<TaskBloc, TaskState>(
                listener: (context, state) {
                  if (state is TaskCreationSuccess) {
                    context.read<TasksBloc>().add(AddTaskToList(task: state.task));
                    context.pop();
                  } else if (state is TaskUpdateSuccess) {
                    context.pop(state.task);
                  }
                },
                builder: (context, state) {
                  if (state is TaskLoading) {
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    );
                  }
                  return Text(
                    widget.task == null ? "Create Task" : "Update Task",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);
  }
}
