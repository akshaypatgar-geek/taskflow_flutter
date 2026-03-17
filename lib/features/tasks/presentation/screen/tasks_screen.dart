import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/network/bloc/network_bloc.dart';
import 'package:taskflowapp/core/offline/service/offline_service.dart';
import 'package:taskflowapp/features/categories/services/category_service.dart';

import '../../../../core/routes/route_extras.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/websocket/socket_service.dart';
import '../../../categories/data/model/category/category.dart';
import '../../data/model/task/task.dart';
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
  String searchKey = "";
  String status = 'all';
  String selectedCategoryId = '';
  String sortBy = 'date';
  String sortOrder = 'desc';
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollThrottle;
  Future<List<Category>>? _categoriesFuture;

  @override
  void initState() {
    _categoriesFuture = widget.categoryService.listCategories().then(
      (cat) => cat ?? [],
    );
    _scrollController.addListener(() {
      _scrollControllerListener();
    });
    super.initState();
  }

  Future<void> connectToWebsocket() async {
    final storage = FlutterSecureStorage();
    final syncService = context.read<OfflineSyncService>();
    final accessToken = await storage.read(key: 'access_token');
    if (accessToken != null) {
      await socketService.connect(accessToken);
      syncService.retryPendingRequests();
    }
  }

  void _searchTasks({required TasksBloc tasksBloc}) async {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 400), () {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        tasksBloc.add(
          ListUserTasks(
            searchKey: searchKey,
            sortBy: sortBy,
            sortOrder: sortOrder,
            status: status == "all" ? null : status,
            categoryId: selectedCategoryId == "" ? null : selectedCategoryId,
          ),
        );
      });
    });
  }

  void _applyFilters({required TasksBloc tasksBloc}) {
    tasksBloc.add(
      ListUserTasks(
        searchKey: searchKey,
        status: status == 'all' ? null : status,
        sortBy: sortBy,
        sortOrder: sortOrder,
        categoryId: selectedCategoryId == "" ? null : selectedCategoryId,
      ),
    );
  }

  void _scrollControllerListener() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_scrollThrottle?.isActive ?? false) return;
      _scrollThrottle = Timer(Duration(milliseconds: 400), () {
        final bloc = context.read<TasksBloc>();
        bloc.add(
          LoadMoreTasks(
            searchKey: searchKey,
            status: status == 'all' ? null : status,
            sortBy: sortBy,
            sortOrder: sortOrder,
            categoryId: selectedCategoryId == "" ? null : selectedCategoryId,
          ),
        );
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
    final colorScheme = Theme.of(context).colorScheme;
    final statusColors = Theme.of(context).extension<AppStatusColors>();
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'TaskFlow',
              style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 5),
            BlocBuilder<NetworkBloc, NetworkState>(
              builder: (context, state) {
                if (state is NetworkOnline) {
                  return CircleAvatar(
                    radius: 6,
                    backgroundColor: statusColors?.done ?? Colors.green,
                  );
                }
                return CircleAvatar(
                  radius: 6,
                  backgroundColor: statusColors?.highPriority ?? colorScheme.error,
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed('profile');
            },
            icon: Icon(Icons.person, color: colorScheme.onSurface),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.sort, color: colorScheme.onSurface),
            onSelected: (value) {
              sortBy = value;
              _applyFilters(tasksBloc: context.read<TasksBloc>());
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'priority',
                child: Text('Sort by Priority'),
              ),
              const PopupMenuItem(
                value: 'date',
                child: Text('Latest on top'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Search tasks...",
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onChanged: (value) {
                  searchKey = value.trim();
                  _searchTasks(tasksBloc: context.read<TasksBloc>());
                },
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Status",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All')),
                        DropdownMenuItem(value: 'OPEN', child: Text('Open')),
                        DropdownMenuItem(
                          value: 'IN_PROGRESS',
                          child: Text('In Progress'),
                        ),
                        DropdownMenuItem(
                          value: 'COMPLETED',
                          child: Text('Completed'),
                        ),
                      ],
                      onChanged: (value) {
                        status = value!;
                        _applyFilters(tasksBloc: context.read<TasksBloc>());
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: FutureBuilder<List<Category>>(
                      future: _categoriesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Text("Error");
                        }

                        final categories = snapshot.data ?? [];

                        return DropdownButtonFormField<String>(
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text("All"),
                            ),
                            ...categories.map(
                              (c) => DropdownMenuItem(
                                value: c.categoryId.toString(),
                                child: Text(
                                  c.categoryName,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            selectedCategoryId = val ?? "";
                            _applyFilters(tasksBloc: context.read<TasksBloc>());
                          },
                          decoration: InputDecoration(
                            labelText: "Category",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: MultiBlocListener(
                listeners: [
                  BlocListener<NetworkBloc, NetworkState>(
                    listener: (context, state) async {
                      if (state is NetworkOnline) {
                        await connectToWebsocket();
                      }
                    },
                  ),
                  BlocListener<TasksBloc, TasksState>(
                    listener: (context, state) {
                      if (state is TasksFailedState) {
                        SnackbarHelper.showErrorMessage(
                          context: context,
                          message: state.errorMessage,
                        );
                      }
                    },
                  ),
                ],
                child: BlocBuilder<TasksBloc, TasksState>(
                  builder: (context, state) {
                    if (state is TasksLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is TasksFailedState) {
                      return Center(child: Text(state.errorMessage));
                    }

                    if (state is TasksListingSuccess) {
                      List<Task> tasks = state.tasks.toList();

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            tasks.length +
                            (state.isFetchingMore ? 1 : 0),
                        itemBuilder: (context, i) {
                          if (i < tasks.length) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TaskTile(
                                task: tasks[i],
                                key: ValueKey(tasks[i].taskId),
                              ),
                            );
                          }

                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        onPressed: () {
          context.pushNamed(
            'taskForm',
            extra: CreateTaskFormExtra(context.read<TasksBloc>()),
          );
        },
        child: Icon(Icons.add, color: colorScheme.onPrimary),
      ),
    );
  }
}
