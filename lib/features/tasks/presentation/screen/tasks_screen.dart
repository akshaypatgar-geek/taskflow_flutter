import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/features/tasks/data/repository/tasks_repository.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../services/websocket/Socket_service.dart';
import '../bloc/tasks/tasks_bloc.dart';
import '../widgets/task_tile.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final SocketService socketService = SocketService();

  @override
  void initState() {
    connectToWebsocket();
    super.initState();
  }

  void connectToWebsocket() async{
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    if(accessToken !=null) {
      socketService.connect(accessToken);
    }
  }
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (ctx)=>TasksRepository(client: ctx.read<DioClient>())),
       
      ],
      child:

        BlocProvider(
          create: (context) => TasksBloc(repository: context.read<TasksRepository>())..add(ListUserTasks()),
          child: Scaffold(
            appBar: AppBar(
              title: Text("TaskFlow"),
              actions: [
                IconButton(onPressed: () {
                  context.pushNamed('profile');
                }, icon: Icon(Icons.person)),
                PopupMenuButton<String>(
              onSelected: (value) {
                // handle sort selection
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'priority',
                  child: Text('Sort by Priority'),
                ),
                PopupMenuItem(
                  value: 'createdAt',
                  child: Text('Sort by Created At'),
                ),
              ],
              icon: Icon(Icons.sort),
            ),
              ],
            ),
            body:  Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    // handle search query
                  },
                ),
                SizedBox(height: 10),
                
                // Filter Row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(value: 'all', child: Text('All')),
                          DropdownMenuItem(value: 'OPEN', child: Text('Open')),
                          DropdownMenuItem(value: 'IM_PROGRESS', child: Text('In Progress')),
                          DropdownMenuItem(value: 'COMPLETED', child: Text('Completed')),
                        ],
                        onChanged: (value) {
                          // handle status filter
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(value: 'all', child: Text('All')),
                          DropdownMenuItem(value: 'work', child: Text('Work')),
                          DropdownMenuItem(value: 'personal', child: Text('Personal')),
                        ],
                        onChanged: (value) {
                          // handle category filter
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                  Expanded(
                    child: BlocConsumer<TasksBloc, TasksState>(
                      listener: (context, state) {
                        if(state is TasksFailedState) {
                          SnackbarHelper.showErrorMessage(context: context, message: state.errorMessage);
                        }
                      },
                      builder: (context, state) {
                        if(state is TasksLoading) {
                          return Center(child: CircularProgressIndicator.adaptive()
                        ,);
                        }
                        if(state is TasksFailedState) return Center(child: Text(state.errorMessage),);
                        if(state is TasksListingSuccess) {
                          return ListView.builder(
                            itemCount: state.tasks.length,
                            itemBuilder: (context, i) {
                              return TaskTile(
                                task: state.tasks[i],
                                key: ValueKey(state.tasks[i].taskId),
                              );
                            },);
                        }
                        return CircularProgressIndicator.adaptive();
                              
                      },),
                  ),
                ],
              ),
            ),
                floatingActionButton: Builder(
  builder: (context) {
    // Now this context definitely sees TasksBloc
    return FloatingActionButton(
      onPressed: () {
        context.pushNamed(
          "taskForm",
          extra: {
            'task': null,
            'bloc': context.read<TasksBloc>(),
          },
        );
      },
      child: Icon(Icons.add),
    );
  },
),
          ),
        ),
      
    );
  }
  
  
}