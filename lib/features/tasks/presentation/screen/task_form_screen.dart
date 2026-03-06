import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';

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
  List<Category> categories = [];
  

  final List<String> priorities = ['LOW', 'MEDIUM', 'HIGH'];

  @override
  void initState() {
    listCategories();
    super.initState();
    
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _selectedPriority = widget.task?.priority ?? priorities[0];
    _selectedCategory = widget.task?.categoryId;
    _status = widget.task?.status ?? TaskStatusEnum.OPEN;
  }

  void listCategories() async {
    final result = await widget.categoryService.listCategories();
    log("result in form :$result");
    if(result !=null) {
      setState(() {
        categories = result;
      });
      
    }
    // log("categories count: ${categories.length}");
    ;
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
      appBar: AppBar(title: Text("Task")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              items: priorities
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedPriority = val),
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
             DropdownButtonFormField(
                value: _selectedCategory,
                items: categories
                    .map((c) => DropdownMenuItem(value: c.categoryId, child: Text(c.categoryName)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val.toString()),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
                
            const SizedBox(height: 16),
            if(widget.task !=null)
            DropdownButtonFormField<TaskStatusEnum>(
              value: _status,
              items: TaskStatusEnum.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _status = val);
              },
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: BlocConsumer<TaskBloc, TaskState>(listener: (context, state) {
              if(state is TaskCreationSuccess) {
                context.read<TasksBloc>().add(AddTaskToList(task: state.task));
                context.pop();
              } else if(state is TaskUpdateSuccess) {
                log("updated");
                context.read<TaskBloc>().add(UpdateToExistingTask(task: state.task));
                context.pop(state.task);
              }
            },
            builder: (context, state) {
              if(state is TaskLoading) return CircularProgressIndicator.adaptive();
              return Text(widget.task == null? "Create Task":"Update task");
            },
            )
              ,
            ),
            
            
          ],
        ),
      ),
    );
  }
}
