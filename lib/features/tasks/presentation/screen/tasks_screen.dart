import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/routes/router.dart';
import 'package:taskflowapp/core/domain/connect_websocket_use_case.dart';
import 'package:taskflowapp/core/network/bloc/network_bloc.dart';
import 'package:taskflowapp/features/categories/domain/entities/category_entity.dart';
import 'package:taskflowapp/features/categories/domain/usecases/list_categories_use_case.dart';

import '../../../../core/routes/route_extras.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/retry_center.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../../core/widgets/surface_card.dart';
import '../bloc/tasks/tasks_bloc.dart';
import '../widgets/task_tile.dart';
import 'package:taskflowapp/core/theme/app_tokens.dart';
import 'package:taskflowapp/core/utils/constants.dart';

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
  String searchKey = '';
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
    _scrollController.addListener(_scrollControllerListener);
    super.initState();
  }

  Future<void> connectToWebsocket() async {
    await widget.connectWebSocketUseCase();
  }

  Future<void> _searchTasks({required TasksBloc tasksBloc}) async {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: AppTokens.throttleMs), () {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        tasksBloc.add(
          ListUserTasks(
            searchKey: searchKey,
            sortBy: sortBy,
            sortOrder: sortOrder,
            status: status == 'all' ? null : status,
            categoryId: selectedCategoryId == '' ? null : selectedCategoryId,
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
        categoryId: selectedCategoryId == '' ? null : selectedCategoryId,
      ),
    );
  }

  Future<void> _scrollControllerListener() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_scrollThrottle?.isActive ?? false) return;
      _scrollThrottle = Timer(const Duration(milliseconds: AppTokens.throttleMs), () {
        final bloc = context.read<TasksBloc>();
        bloc.add(
          LoadMoreTasks(
            searchKey: searchKey,
            status: status == 'all' ? null : status,
            sortBy: sortBy,
            sortOrder: sortOrder,
            categoryId: selectedCategoryId == '' ? null : selectedCategoryId,
          ),
        );
      });
    }
  }

  Widget _buildTasksBody(TasksState state) {
    if (state is TasksLoading) {
      return const AppLoadingIndicator(
        key: ValueKey(AppStrings.loadingstate),
      );
    }

    if (state is TasksFailedState) {
      return RetryCenter(
        key: const ValueKey(AppStrings.errorState),
        message: state.errorMessage,
        onRetry: () => _applyFilters(
          tasksBloc: context.read<TasksBloc>(),
        ),
      );
    }

    if (state is TasksListingSuccess) {
      final tasks = state.tasks.toList();

      return LayoutBuilder(
        key: const ValueKey('tasks_success'),
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = width > AppTokens.breakpointXl
              ? 3
              : width > AppTokens.breakpointMd
                  ? 2
                  : 1;
          final itemCount = tasks.length + (state.isFetchingMore ? 1 : 0);

          if (crossAxisCount == 1) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: itemCount,
              itemBuilder: (context, i) {
                if (i < tasks.length) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppTokens.sL),
                    child: TaskTile(
                      task: tasks[i],
                      key: ValueKey(tasks[i].taskId),
                    ),
                  );
                }

                return const Padding(
                  padding: EdgeInsets.all(AppTokens.sXl),
                  child: AppLoadingIndicator(),
                );
              },
            );
          }

          return GridView.builder(
            controller: _scrollController,
            itemCount: itemCount,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: AppTokens.sL,
              crossAxisSpacing: AppTokens.sL,
              childAspectRatio: crossAxisCount < 3 ? 3.2 : 2.6,
            ),
            itemBuilder: (context, i) {
              if (i < tasks.length) {
                return TaskTile(
                  task: tasks[i],
                  key: ValueKey(tasks[i].taskId),
                );
              }

              return const Padding(
                padding: EdgeInsets.all(AppTokens.sXl),
                child: AppLoadingIndicator(),
              );
            },
          );
        },
      );
    }

    return RetryCenter(
      key: const ValueKey(AppStrings.defaultState),
      message: AppStrings.unableToLoadTasks,
      onRetry: () => _applyFilters(
        tasksBloc: context.read<TasksBloc>(),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _scrollThrottle?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWideLayout = MediaQuery.sizeOf(context).width >= 900;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Row(
          children: [
            Text(
              AppStrings.taskFlowTitle,
              style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: AppTokens.sM),
            BlocBuilder<NetworkBloc, NetworkState>(
              builder: (context, state) {
                final isOnline = state is NetworkOnline;
               return Semantics(
      label: isOnline ? AppStrings.networkOnline : AppStrings.networkOffline,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: AppTokens.r,
              backgroundColor: isOnline
                  ? AppStatusColors.of(context).done
                  : AppStatusColors.of(context).highPriority,
            ),
            const SizedBox(width: AppTokens.s),
            Text(
              isOnline ? AppStrings.networkOnline : AppStrings.networkOffline,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
              },
            ),
          ],
        ),
        actions: [
          
          Semantics(
            label: AppStrings.sortTasks,
            tooltip: AppStrings.sortTasks,
            button: true,
            child: PopupMenuButton<String>(
              icon: Icon(Icons.sort, color: colorScheme.onSurface),
              onSelected: (value) {
                sortBy = value;
                _applyFilters(tasksBloc: context.read<TasksBloc>());
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'priority',
                  child: Text(AppStrings.sortByPriority),
                ),
                const PopupMenuItem(
                  value: 'date',
                  child: Text(AppStrings.latestOnTop),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ResponsiveContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppTokens.sL),
            child: Column(
          children: [
            SurfaceCard(
              padding: const EdgeInsets.symmetric(horizontal: AppTokens.sXl, vertical: AppTokens.sM),
              child: Semantics(
                tooltip: AppStrings.searchTasksHint,
                label: AppStrings.searchTasksHint,
                child: TextFormField(
                  decoration:const InputDecoration(
                    hintText: AppStrings.searchTasksHint,
                    prefixIcon:  Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding:  EdgeInsets.symmetric(vertical: AppTokens.sXl),
                  ),
                  onChanged: (value) {
                    searchKey = value.trim();
                    _searchTasks(tasksBloc: context.read<TasksBloc>());
                  },
                ),
              ),
            ),

            const SizedBox(height: AppTokens.sXl),

            SurfaceCard(
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: AppStrings.statusLabel,
                ),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text(AppStrings.all)),
                        DropdownMenuItem(value: 'OPEN', child: Text(AppStrings.open)),
                        DropdownMenuItem(
                          value: 'IN_PROGRESS',
                          child: Text(AppStrings.inProgress),
                        ),
                        DropdownMenuItem(
                          value: 'COMPLETED',
                          child: Text(AppStrings.completed),
                        ),
                      ],
                      onChanged: (value) {
                        status = value!;
                        _applyFilters(tasksBloc: context.read<TasksBloc>());
                      },
                    ),
                  ),

                  const SizedBox(width: AppTokens.sL),

                  Expanded(
                    child: FutureBuilder<List<CategoryEntity>>(
                      future: _categoriesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(AppTokens.sXxxl),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Text(AppStrings.genericError);
                        }

                        final categories = snapshot.data ?? [];

                        return DropdownButtonFormField<String>(
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text(AppStrings.all),
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
                            selectedCategoryId = val ?? '';
                            _applyFilters(tasksBloc: context.read<TasksBloc>());
                          },
                          decoration: const InputDecoration(
                            labelText: AppStrings.categoryLabel,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTokens.sXl),

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
                buildWhen: (previous, current) {
                  if (previous.runtimeType != current.runtimeType) {
    return true;
  }
  if (previous is TasksListingSuccess && current is TasksListingSuccess) {
    return previous.tasks != current.tasks ||
        previous.isFetchingMore != current.isFetchingMore;
  }
  return false;
                },
                  builder: (context, state) {
                    return AnimatedSwitcher(
                      duration:const  Duration(milliseconds: AppTokens.animateMs),
                      child: _buildTasksBody(state),);
                    
                  },
                ),
              ),
            ),
            ],
            ),
          ),
        ),
      

      floatingActionButton:  Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if(!isWideLayout)
                Semantics(
                  label: AppStrings.openProfile,
                  tooltip: AppStrings.openProfile,
                  button: true,
                  child: FloatingActionButton(
                    heroTag: 'tasks_fab_profile',
                    backgroundColor: colorScheme.primary,
                    onPressed: () {
                      context.pushNamed(ScreenPaths.profile.name);
                    },
                    tooltip: AppStrings.profile,
                    child: Icon(Icons.person, color: colorScheme.onPrimary),
                  ),
                ),
                const SizedBox(height: AppTokens.sM),
                Semantics(
                  label: AppStrings.addNewTask,
                  tooltip: AppStrings.addNewTask,
                  button: true,
                  child: FloatingActionButton(
                    heroTag: 'tasks_fab_new_task',
                    backgroundColor: colorScheme.primary,
                    tooltip: AppStrings.addNewTask,
                    onPressed: () {
                      context.pushNamed(
                        ScreenPaths.taskForm.name,
                        extra: CreateTaskFormExtra(context.read<TasksBloc>()),
                      );
                    },
                    child: Icon(Icons.add, color: colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
    );
  }


}
