import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/core/utils/snackbar_helper.dart';
import 'package:taskflowapp/features/tasks/data/repository/task_repository.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/task/task_bloc.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';

import '../../data/model/task/task.dart';

class TaskDetailsScreen extends StatelessWidget {
  
  final String taskId;
  

  const TaskDetailsScreen({
    super.key,
    required this.taskId,
  });

  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? '-')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon:  BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) return CircularProgressIndicator.adaptive();
                return Icon(Icons.delete);
              },
              ),
            onPressed: () {
              showDialog(context: context, builder: (ctx) {
                return AlertDialog.adaptive(
                  title: Text("Delete Task?"),
                  actions: [
                    TextButton(onPressed: ()=>ctx.pop(), child: Text("No, Cancel")),
                    TextButton(onPressed: () {
                      ctx.pop();
                       context.read<TaskBloc>().add(DeleteTask(taskId: taskId));
                    }, child: Text("Delete"))
                  ],
                );
              },);
            
            },
          )
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if(state is TaskFailedState) {
            SnackbarHelper.showErrorMessage(context: context, message: state.errorMessage);
          } else if(state is TaskDeletionSuccess) {
            
            context.read<TasksBloc>().add(RemoveTaskFromList(taskId: state.taskId));
            context.pop();
          }
        },
        builder: (context, state) {
          if(state is TaskFailedState) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if(state is TaskLoading) {
            return Center(child: CircularProgressIndicator.adaptive(),);
          } else if(state is TaskDetailsSuccess) {
            final task = state.task;
            return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Title', task.title),
            _buildRow('Priority', task.priority),
            _buildRow('Status', task.status.name),
            _buildRow('Category', task.categoryId),
            _buildRow(
                'Created At', task.createdAt.toLocal().toString().split('.')[0]),
            _buildRow(
                'Updated At', task.updatedAt.toLocal().toString().split('.')[0]),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Update Task'),
                onPressed: ()async {
                final Task? updatedTask=await  context.pushNamed('taskForm',
                  extra: {
                    'task':task,
                    'bloc': context.read<TaskBloc>()
                  });
                  if(updatedTask !=null) {
                    context.read<TasksBloc>().add(UpdateOneTask(task: updatedTask));
                  }
                },
              ),
            ),
          ],
        ),
      );
          }
          return CircularProgressIndicator.adaptive();
        },)
      
    );
  }
}