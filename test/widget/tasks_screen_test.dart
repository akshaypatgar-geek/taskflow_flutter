import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflowapp/core/domain/connect_websocket_use_case.dart';
import 'package:taskflowapp/core/offline/service/offline_service.dart';
import 'package:taskflowapp/core/network/bloc/network_bloc.dart';
import 'package:taskflowapp/features/categories/domain/usecases/list_categories_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_entity/task_entity.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/delete_task_locally_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/get_cached_filtered_tasks_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/list_user_tasks_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/save_task_locally_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/watch_task_updates_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/entities/list_tasks_result.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:taskflowapp/features/tasks/presentation/screen/tasks_screen.dart';

import '../helpers/widget_test_helpers.dart';
import 'categories_screen_test.dart';

class MockGetCachedFilteredTasksUseCase extends Mock
    implements GetCachedFilteredTasksUseCase {}

class MockListUserTasksUseCase extends Mock implements ListUserTasksUseCase {}

class MockSaveTaskLocallyUseCase extends Mock
    implements SaveTaskLocallyUseCase {}

class MockDeleteTaskLocallyUseCase extends Mock
    implements DeleteTaskLocallyUseCase {}

class MockWatchTaskUpdatesUseCase extends Mock
    implements WatchTaskUpdatesUseCase {}

class MockListCategoriesUseCase extends Mock implements ListCategoriesUseCase {}

class MockConnectWebSocketUseCase extends Mock
    implements ConnectWebSocketUseCase {}

void main() {
  late TasksBloc tasksBloc;
  late MockGetCachedFilteredTasksUseCase mockGetCached;
  late MockListUserTasksUseCase mockListTasks;
  late MockListCategoriesUseCase mockListCategories;
  late MockConnectWebSocketUseCase mockConnectWebSocket;
  late MockGetCachedCategoriesUseCase getCachedCategories;

  setUp(() {
    mockGetCached = MockGetCachedFilteredTasksUseCase();
    mockListTasks = MockListUserTasksUseCase();
    mockListCategories = MockListCategoriesUseCase();
    mockConnectWebSocket = MockConnectWebSocketUseCase();
    getCachedCategories = MockGetCachedCategoriesUseCase();

    when(
      () => mockGetCached(
        categoryId: any(named: 'categoryId'),
        searchKey: any(named: 'searchKey'),
        sortBy: any(named: 'sortBy'),
        sortOrder: any(named: 'sortOrder'),
        status: any(named: 'status'),
      ),
    ).thenAnswer((_) async => []);
    when(
      () => mockListTasks(
        categoryId: any(named: 'categoryId'),
        searchKey: any(named: 'searchKey'),
        sortBy: any(named: 'sortBy'),
        sortOrder: any(named: 'sortOrder'),
        status: any(named: 'status'),
      ),
    ).thenAnswer(
      (_) async => const Right(
        ListTasksResult(tasks: [], nextCursor: null, hasNextPage: false),
      ),
    );
    when(() => mockListCategories()).thenAnswer((_) async => const Right([]));
    when(
      () => mockConnectWebSocket(),
    ).thenAnswer((_) async => const OfflineSyncResult());

    tasksBloc = TasksBloc(
      getCachedFilteredTasksUseCase: mockGetCached,
      listUserTasksUseCase: mockListTasks,
      saveTaskLocallyUseCase: MockSaveTaskLocallyUseCase(),
      deleteTaskLocallyUseCase: MockDeleteTaskLocallyUseCase(),
      watchTaskUpdatesUseCase: MockWatchTaskUpdatesUseCase(),
    );
  });

  tearDown(() => tasksBloc.close());

  late NetworkBloc networkBloc;

  setUpAll(() {
    networkBloc = NetworkBloc(repository: StubNetworkRepository())
      ..add(StartNetworkMonitoring());
  });

  group('TasksScreen', () {
    testWidgets('renders TaskFlow title and search', (tester) async {
      await pumpTestWidget(
        tester,
        TasksScreen(
          listCategoriesUseCase: mockListCategories,
          connectWebSocketUseCase: mockConnectWebSocket,
          getCachedCategoriesUseCase: getCachedCategories,
        ),
        tasksBloc: tasksBloc,
        networkBloc: networkBloc,
      );
      tasksBloc.add(ListUserTasks());
      await tester.pumpAndSettle();

      expect(find.text('TaskFlow'), findsOneWidget);
      expect(find.bySemanticsLabel('Search tasks'), findsOneWidget);
    });

    testWidgets('shows task list when loaded', (tester) async {
      final tasks = [
        TaskEntity(
          taskId: '1',
          title: 'Task 1',
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
          authorId: 'user1',
        ),
      ];
      when(
        () => mockGetCached(
          categoryId: any(named: 'categoryId'),
          searchKey: any(named: 'searchKey'),
          sortBy: any(named: 'sortBy'),
          sortOrder: any(named: 'sortOrder'),
          status: any(named: 'status'),
        ),
      ).thenAnswer((_) async => []);
      when(
        () => mockListTasks(
          categoryId: any(named: 'categoryId'),
          searchKey: any(named: 'searchKey'),
          sortBy: any(named: 'sortBy'),
          sortOrder: any(named: 'sortOrder'),
          status: any(named: 'status'),
        ),
      ).thenAnswer(
        (_) async => Right(
          ListTasksResult(tasks: tasks, nextCursor: null, hasNextPage: false),
        ),
      );

      await pumpTestWidget(
        tester,
        TasksScreen(
          listCategoriesUseCase: mockListCategories,
          connectWebSocketUseCase: mockConnectWebSocket,
          getCachedCategoriesUseCase: getCachedCategories,
        ),
        tasksBloc: tasksBloc,
        networkBloc: networkBloc,
      );
      tasksBloc.add(ListUserTasks());
      await tester.pumpAndSettle();

      expect(find.text('Task 1'), findsOneWidget);
    });

    testWidgets('has Add new task FAB with semantic label', (tester) async {
      await pumpTestWidget(
        tester,
        TasksScreen(
          listCategoriesUseCase: mockListCategories,
          connectWebSocketUseCase: mockConnectWebSocket,
          getCachedCategoriesUseCase: getCachedCategories,
        ),
        tasksBloc: tasksBloc,
        networkBloc: networkBloc,
      );
      tasksBloc.add(ListUserTasks());
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Add new task'), findsOneWidget);
    });
  });
}
