import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';

import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository_interface.dart';
import '../../features/auth/domain/usecases/check_session_use_case.dart';
import '../../features/auth/domain/usecases/login_use_case.dart';
import '../../features/auth/domain/usecases/logout_use_case.dart';
import '../../features/auth/domain/usecases/sign_up_use_case.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/categories/data/datasource/local/category_datasource_local.dart';
import '../../features/categories/data/datasource/local/category_datasource_local_impl.dart';
import '../../features/categories/data/repository/category_repository_impl.dart';
import '../../features/categories/data/repository/local_category_repository_adapter.dart';
import '../../features/categories/domain/repository/category_repository_interface.dart';
import '../../features/categories/domain/repository/local_category_repository_interface.dart';
import '../../features/categories/domain/usecases/create_category_use_case.dart';
import '../../features/categories/domain/usecases/get_cached_categories_use_case.dart';
import '../../features/categories/domain/usecases/get_category_details_use_case.dart';
import '../../features/categories/domain/usecases/list_categories_use_case.dart';
import '../../features/categories/presentation/bloc/categories_bloc.dart';
import '../../features/profile/data/datasources/local/profile_datasource_local.dart';
import '../../features/profile/data/datasources/profile_datasource_interface.dart';
import '../../features/profile/data/datasources/profile_datasource_local.dart';
import '../../features/profile/data/datasources/remote/profile_datasource_remote.dart';
import '../../features/profile/data/repository/profile_repository_impln.dart';
import '../../features/profile/domain/repository/profile_repository_interface.dart';
import '../../features/profile/domain/usecases/get_profile_details_use_case.dart';
import '../../features/profile/domain/usecases/update_profile_use_case.dart';
import '../../features/profile/presentation/bloc/profile/profile_bloc.dart';
import '../../features/session_manager/session_manager.dart';
import '../../features/tasks/data/datasource/local/tasks_datasource_local.dart';
import '../../features/tasks/data/datasource/local/taks_datasource_local_impl.dart';
import '../../features/tasks/data/datasource/remote/task_datasource_remote.dart';
import '../../features/tasks/data/datasource/remote/task_datasource_remote_impl.dart';
import '../../features/tasks/data/datasource/remote/tasks_datasource_remote.dart';
import '../../features/tasks/data/datasource/remote/tasks_datasource_remote_impl.dart';
import '../../features/tasks/data/repository/task_repository_impl.dart';
import '../../features/tasks/data/repository/task_updates_repository_impl.dart';
import '../../features/tasks/data/repository/tasks_repository_impl.dart';
import '../../features/tasks/domain/repository/local_tasks_repository_interface.dart';
import '../../features/tasks/domain/repository/task_repository_interface.dart';
import '../../features/tasks/domain/repository/task_updates_repository_interface.dart';
import '../../features/tasks/domain/repository/tasks_repository_interface.dart';
import '../../features/tasks/domain/usecases/create_task_use_case.dart';
import '../../features/tasks/domain/usecases/delete_task_locally_use_case.dart';
import '../../features/tasks/domain/usecases/delete_task_use_case.dart';
import '../../features/tasks/domain/usecases/get_cached_filtered_tasks_use_case.dart';
import '../../features/tasks/domain/usecases/get_task_details_use_case.dart';
import '../../features/tasks/domain/usecases/list_user_tasks_use_case.dart';
import '../../features/tasks/domain/usecases/save_task_locally_use_case.dart';
import '../../features/tasks/domain/usecases/update_task_use_case.dart';
import '../../features/tasks/domain/usecases/watch_task_updates_use_case.dart';
import '../../features/categories/local/model/category_hive/category_hive.dart';
import '../../features/tasks/local/model/task_hive/task_hive.dart';
import '../../features/tasks/data/repository/local_tasks_repository_adapter.dart';
import '../../features/tasks/presentation/bloc/task/task_bloc.dart';
import '../../features/tasks/presentation/bloc/tasks/tasks_bloc.dart';
import '../network/bloc/network_bloc.dart';
import '../network/dio_client.dart';
import '../network/network_repository.dart';
import '../network/network_service.dart';
import '../offline/offline_request_hive.dart';
import '../domain/connect_websocket_use_case.dart';
import '../offline/repository/offline_request_repository.dart';
import '../offline/service/offline_service.dart';
import '../socket_service.dart';
import '../../features/profile/data/datasources/local/model/user_details_hive.dart';

final GetIt sl = GetIt.instance;


Future<void> initInjector() async {
  _registerCore();
  _registerAuth();
  _registerProfile();
  _registerTasks();
  _registerCategories();
  _registerBlocs();
}

void _registerCore() {
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<DioClient>(
    () => DioClient(storage: sl<FlutterSecureStorage>()),
  );
  sl.registerLazySingleton<SessionManager>(
    () => SessionManager(storage: sl<FlutterSecureStorage>()),
  );
  sl.registerLazySingleton<NetworkService>(() => NetworkService());
  sl.registerLazySingleton<NetworkRepository>(
    () => NetworkRepository(service: sl<NetworkService>()),
  );
  sl.registerLazySingleton<OfflineRequestRepository>(
    () => OfflineRequestRepository(
      offlineBox: Hive.box<OfflineRequestHive>('offlineRequests'),
      client: sl<DioClient>(),
    ),
  );
  sl.registerLazySingleton<SocketService>(() => SocketService());
  sl.registerLazySingleton<OfflineSyncService>(
    () => OfflineSyncService(sl<OfflineRequestRepository>()),
  );
  sl.registerLazySingleton<ConnectWebSocketUseCase>(
    () => ConnectWebSocketUseCase(
      sessionManager: sl<SessionManager>(),
      socketService: sl<SocketService>(),
      offlineSyncService: sl<OfflineSyncService>(),
    ),
  );
}

void _registerAuth() {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      client: sl<DioClient>(),
      sessionManager: sl<SessionManager>(),
    ),
  );
  sl.registerLazySingleton<CheckSessionUseCase>(
    () => CheckSessionUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<AuthRepository>()),
  );
}

void _registerProfile() {
  sl.registerLazySingleton<ProfileDatasourceLocal>(
    () => ProfileDatasourceLocalImpl(
      userBox: Hive.box<UserDetailsHive>('userBox'),
    ),
  );
  sl.registerLazySingleton<ProfileDatasourceRemote>(
    () => ProfileDatasourceRemoteImpl(dioClient: sl<DioClient>()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpln(
      localDataSource: sl<ProfileDatasourceLocal>(),
      remoteDataSource: sl<ProfileDatasourceRemote>(),
    ),
  );
  sl.registerLazySingleton<GetProfileDetailsUseCase>(
    () => GetProfileDetailsUseCase(sl<ProfileRepository>()),
  );
  sl.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(sl<ProfileRepository>()),
  );
}

void _registerTasks() {
  sl.registerLazySingleton<TasksDatasourceLocal>(
    () => TaksDatasourceLocalImpl(
      taskBox: Hive.box<TaskHive>('tasks'),
    ),
  );
  sl.registerLazySingleton<TasksDatasourceRemote>(
    () => TasksDatasourceRemoteImpl(client: sl<DioClient>()),
  );
  sl.registerLazySingleton<TasksRepository>(
    () => TasksRepositoryImpl(
      localDatasource: sl<TasksDatasourceLocal>(),
      remoteDataSource: sl<TasksDatasourceRemote>(),
    ),
  );
  sl.registerLazySingleton<LocalTasksRepositoryInterface>(
    () => LocalTasksRepositoryAdapter(sl<TasksDatasourceLocal>()),
  );
  sl.registerLazySingleton<TaskUpdatesRepository>(
    () => TaskUpdatesRepositoryImpl(sl<SocketService>()),
  );
  sl.registerLazySingleton<WatchTaskUpdatesUseCase>(
    () => WatchTaskUpdatesUseCase(sl<TaskUpdatesRepository>()),
  );
  sl.registerLazySingleton<TaskDatasourceRemote>(
    () => TaskDatasourceRemoteImpl(client: sl<DioClient>()),
  );
  sl.registerLazySingleton<TaskRepositoryInterface>(
    () => TaskRepositoryImpl(
      remoteDatasource: sl<TaskDatasourceRemote>(),
      localDatasource: sl<TasksDatasourceLocal>(),
      offlineRequestRepository: sl<OfflineRequestRepository>(),
    ),
  );
  sl.registerLazySingleton<GetTaskDetailsUseCase>(
    () => GetTaskDetailsUseCase(sl<TaskRepositoryInterface>()),
  );
  sl.registerLazySingleton<CreateTaskUseCase>(
    () => CreateTaskUseCase(sl<TaskRepositoryInterface>()),
  );
  sl.registerLazySingleton<UpdateTaskUseCase>(
    () => UpdateTaskUseCase(sl<TaskRepositoryInterface>()),
  );
  sl.registerLazySingleton<DeleteTaskUseCase>(
    () => DeleteTaskUseCase(sl<TaskRepositoryInterface>()),
  );
  sl.registerLazySingleton<GetCachedFilteredTasksUseCase>(
    () => GetCachedFilteredTasksUseCase(sl<LocalTasksRepositoryInterface>()),
  );
  sl.registerLazySingleton<ListUserTasksUseCase>(
    () => ListUserTasksUseCase(repository: sl<TasksRepository>()),
  );
  sl.registerLazySingleton<SaveTaskLocallyUseCase>(
    () => SaveTaskLocallyUseCase(sl<LocalTasksRepositoryInterface>()),
  );
  sl.registerLazySingleton<DeleteTaskLocallyUseCase>(
    () => DeleteTaskLocallyUseCase(sl<LocalTasksRepositoryInterface>()),
  );
}

void _registerCategories() {
  sl.registerLazySingleton<CategoryDatasourceLocal>(
    () => CategoryDatasourceLocalImpl(
      categoryBox: Hive.box<CategoryHive>('categories'),
    ),
  );
  sl.registerLazySingleton<LocalCategoryRepositoryInterface>(
    () => LocalCategoryRepositoryAdapter(sl<CategoryDatasourceLocal>()),
  );
  sl.registerLazySingleton<CategoryRepositoryInterface>(
    () => CategoryRepositoryImpl(
      sl<DioClient>(),
      localRepository: sl<LocalCategoryRepositoryInterface>(),
    ),
  );
  sl.registerLazySingleton<GetCachedCategoriesUseCase>(
    () => GetCachedCategoriesUseCase(sl<LocalCategoryRepositoryInterface>()),
  );
  sl.registerLazySingleton<ListCategoriesUseCase>(
    () => ListCategoriesUseCase(sl<CategoryRepositoryInterface>()),
  );
  sl.registerLazySingleton<CreateCategoryUseCase>(
    () => CreateCategoryUseCase(sl<CategoryRepositoryInterface>()),
  );
  sl.registerLazySingleton<GetCategoryDetailsUseCase>(
    () => GetCategoryDetailsUseCase(sl<CategoryRepositoryInterface>()),
  );
}

void _registerBlocs() {
  sl.registerLazySingleton<NetworkBloc>(
    () => NetworkBloc(repository: sl<NetworkRepository>())
      ..add(StartNetworkMonitoring()),
  );
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      checkSessionUseCase: sl<CheckSessionUseCase>(),
      loginUseCase: sl<LoginUseCase>(),
      signUpUseCase: sl<SignUpUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
    )..add(CheckSessionEvent()),
  );
  sl.registerFactory<TasksBloc>(
    () => TasksBloc(
      getCachedFilteredTasksUseCase: sl<GetCachedFilteredTasksUseCase>(),
      listUserTasksUseCase: sl<ListUserTasksUseCase>(),
      saveTaskLocallyUseCase: sl<SaveTaskLocallyUseCase>(),
      deleteTaskLocallyUseCase: sl<DeleteTaskLocallyUseCase>(),
      watchTaskUpdatesUseCase: sl<WatchTaskUpdatesUseCase>(),
    ),
  );
  sl.registerFactory<TaskBloc>(
    () => TaskBloc(
      getTaskDetailsUseCase: sl<GetTaskDetailsUseCase>(),
      createTaskUseCase: sl<CreateTaskUseCase>(),
      updateTaskUseCase: sl<UpdateTaskUseCase>(),
      deleteTaskUseCase: sl<DeleteTaskUseCase>(),
      watchTaskUpdatesUseCase: sl<WatchTaskUpdatesUseCase>(),
    ),
  );
  sl.registerFactory<CategoriesBloc>(
    () => CategoriesBloc(
      getCachedCategoriesUseCase: sl<GetCachedCategoriesUseCase>(),
      listCategoriesUseCase: sl<ListCategoriesUseCase>(),
      createCategoryUseCase: sl<CreateCategoryUseCase>(),
    ),
  );
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getProfileDetailsUseCase: sl<GetProfileDetailsUseCase>(),
      updateProfileUseCase: sl<UpdateProfileUseCase>(),
    ),
  );
}
