import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/domain/connect_websocket_use_case.dart';
import 'package:taskflowapp/core/network/bloc/network_bloc.dart';
import 'package:taskflowapp/features/categories/domain/entities/category_entity.dart';
import 'package:taskflowapp/features/categories/domain/usecases/list_categories_use_case.dart';

import '../../../../core/routes/route_extras.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/surface_card.dart';
import '../bloc/tasks/tasks_bloc.dart';
import '../widgets/task_tile.dart';

class TasksScreen extends StatefulWidget {
  final ListCategoriesUseCase listCategoriesUseCase;
  final ConnectWebSocketUseCase connectWebSocketUseCase;
  const TasksScreen({
    super.key,
    required this.listCategoriesUseCase,
    required this.connectWebSocketUseCase,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  Timer? _debounce;
  String searchKey = "";
  String status = 'all';
  String selectedCategoryId = '';
  String sortBy = 'date';
  String sortOrder = 'desc';
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollThrottle;
  Future<List<CategoryEntity>>? _categoriesFuture;

  @override
  void initState() {
    _categoriesFuture = widget.listCategoriesUseCase().then(
      (result) => result.fold((_) => <CategoryEntity>[], (r) => r),
    );
    _scrollController.addListener(() {
      _scrollControllerListener();
    });
    super.initState();
  }

  Future<void> connectToWebsocket() async {
    await widget.connectWebSocketUseCase();
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
                    backgroundColor: AppStatusColors.of(context).done,
                  );
                }
                return CircleAvatar(
                  radius: 6,
                  backgroundColor: AppStatusColors.of(context).highPriority,
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
            tooltip: 'Profile',
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
            SurfaceCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Semantics(
                label: 'Search tasks',
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
            ),

            const SizedBox(height: 16),

            SurfaceCard(
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Status",
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
                    child: FutureBuilder<List<CategoryEntity>>(
                      future: _categoriesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
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
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            selectedCategoryId = val ?? "";
                            _applyFilters(tasksBloc: context.read<TasksBloc>());
                          },
                          decoration: const InputDecoration(
                            labelText: "Category",
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
                      return const AppLoadingIndicator();
                    }

                    if (state is TasksFailedState) {
                      return Center(child: Text(state.errorMessage));
                    }

                    if (state is TasksListingSuccess) {
                      final tasks = state.tasks.toList();

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
                            child: AppLoadingIndicator(),
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

      floatingActionButton: Semantics(
        label: 'Add new task',
        child: FloatingActionButton(
          backgroundColor: colorScheme.primary,
          onPressed: () {
            context.pushNamed(
              'taskForm',
              extra: CreateTaskFormExtra(context.read<TasksBloc>()),
            );
          },
          child: Icon(Icons.add, color: colorScheme.onPrimary),
        ),
      ),
    );
  }
}
