import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/network/network_service.dart';
import 'package:taskflowapp/core/offline/repository/offline_request_repository.dart';
import 'package:taskflowapp/core/offline/service/offline_service.dart';
import 'package:taskflowapp/features/categories/services/category_service.dart';
import 'package:taskflowapp/features/tasks/data/repository/tasks_repository.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../services/websocket/Socket_service.dart';
import '../../../categories/data/model/category/category.dart';
import '../bloc/tasks/tasks_bloc.dart';
import '../widgets/task_tile.dart';

class TasksScreen extends StatefulWidget {
  final CategoryService categoryService;
  const TasksScreen({super.key, required this.categoryService});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final SocketService socketService = SocketService();
  Timer? _debounce;
  String searchKey="";
  String status = 'all';
  String selectedCategoryId = '';
  String sortBy = 'date';
  String sortOrder = 'desc';
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollThrottle;
  Future<List<Category>>? _categoriesFuture;
  

  @override
  void initState() {
    connectToWebsocket();
    _listenToConnection();
    _categoriesFuture = widget.categoryService.listCategories().then((cat)=>cat??[]);
    _scrollController.addListener(() {
    _scrollControllerListener();
  });
    super.initState();
  }

  void connectToWebsocket() async{
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    if(accessToken !=null) {
      socketService.connect(accessToken);
    }
  }

  void _listenToConnection() async {
    final networkService = context.read<NetworkService>();
    final syncService = context.read<OfflineSyncService>();
    networkService.startListening(onConnected: syncService.retryPendingRequests);
  }

  void _searchTasks({required TasksBloc tasksBloc}) async {

    if(_debounce?.isActive??false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(
      milliseconds: 400,
    ), () {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        tasksBloc.add(ListUserTasks(
        searchKey: searchKey,
        sortBy: sortBy,
        sortOrder: sortOrder,
        status: status
      ));
      },);
      
    },);
  }

  void _applyFilters({required TasksBloc tasksBloc}) {
  tasksBloc.add(ListUserTasks(
    searchKey: searchKey,
    status: status,
    sortBy: sortBy,
    sortOrder: sortOrder,
    categoryId: selectedCategoryId
    
  ));
}

void _scrollControllerListener() async {
   
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_scrollThrottle?.isActive ?? false) return;
      _scrollThrottle = Timer(Duration(milliseconds: 400), () {
        final bloc = context.read<TasksBloc>();
        bloc.add(LoadMoreTasks(
          searchKey: searchKey,
          status: status,
          sortBy: sortBy,
          sortOrder: sortOrder,
        ));
      });
    }
  
}

@override
void dispose() {
  _scrollController.dispose();
  _scrollThrottle?.cancel();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TaskFlow"),
        actions: [
          IconButton(onPressed: () {
            context.pushNamed('profile');
          }, icon: Icon(Icons.person)),
          PopupMenuButton<String>(
        onSelected: (value) {
          sortBy = value;
          _applyFilters(tasksBloc: context.read<TasksBloc>());
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'priority',
            child: Text('Sort by Priority'),
          ),
          PopupMenuItem(
            value: 'date',
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
              searchKey = value;
              _searchTasks(tasksBloc: context.read<TasksBloc>());
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
                    DropdownMenuItem(value: 'IN_PROGRESS', child: Text('In Progress')),
                    DropdownMenuItem(value: 'COMPLETED', child: Text('Completed')),
                  ],
                  onChanged: (value) {
                    status = value!;
                    _applyFilters(tasksBloc: context.read<TasksBloc>());
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: FutureBuilder<List<Category>>(future: _categoriesFuture, builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final categories = snapshot.data ?? [];
        return DropdownButtonFormField<String>(
          // value: selectedCategoryId,
          items:[
            const DropdownMenuItem(
      value: null,
      child: Text("All"),
    ),
    ...categories
              .map(
                (c) => DropdownMenuItem(
                  value: c.categoryId.toString(),
                  child: Text(c.categoryName),
                ),
              )
              
          ] ,
          onChanged: (val)  {
            selectedCategoryId = val??"";
             _applyFilters(tasksBloc: context.read<TasksBloc>());
          },
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
        );
                },),
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
                      controller: _scrollController,
                      itemCount: state.tasks.length + (context.read<TasksBloc>().isFetchingMore ? 1 : 0),
                      itemBuilder: (context, i) {
                        if(i<state.tasks.length) {
                          return TaskTile(
                          task: state.tasks[i],
                          key: ValueKey(state.tasks[i].taskId),
                        );
                        } else {
                          return CircularProgressIndicator.adaptive();
                        }
                        
                      },
                      );
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
    );
  }
  
  
}