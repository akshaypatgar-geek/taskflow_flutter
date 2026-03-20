import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/network/bloc/network_bloc.dart';
import 'package:taskflowapp/core/network/network_repository.dart';
import 'package:taskflowapp/core/network/network_service.dart';
import 'package:taskflowapp/core/theme/app_theme.dart';
import 'package:taskflowapp/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:taskflowapp/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:taskflowapp/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/task/task_bloc.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';

/// Stub repository that emits online immediately (for TasksScreen tests).
class StubNetworkRepository implements NetworkRepository {
  StubNetworkRepository() : service = NetworkService();

  @override
  final NetworkService service;

  @override
  Stream<bool> get connectionStream => Stream.value(true);
}

/// Pumps a widget wrapped with MaterialApp, theme, and optional bloc providers.
Future<void> pumpTestWidget(
  WidgetTester tester,
  Widget child, {
  AuthBloc? authBloc,
  CategoriesBloc? categoriesBloc,
  ProfileBloc? profileBloc,
  TasksBloc? tasksBloc,
  TaskBloc? taskBloc,
  NetworkBloc? networkBloc,
}) async {
  final providers = <BlocProvider>[];
  if (authBloc != null) providers.add(BlocProvider<AuthBloc>.value(value: authBloc));
  if (categoriesBloc != null) providers.add(BlocProvider<CategoriesBloc>.value(value: categoriesBloc));
  if (profileBloc != null) providers.add(BlocProvider<ProfileBloc>.value(value: profileBloc));
  if (tasksBloc != null) providers.add(BlocProvider<TasksBloc>.value(value: tasksBloc));
  if (taskBloc != null) providers.add(BlocProvider<TaskBloc>.value(value: taskBloc));
  if (networkBloc != null) providers.add(BlocProvider<NetworkBloc>.value(value: networkBloc));

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: providers.isEmpty
          ? child
          : MultiBlocProvider(
              providers: providers,
              child: child,
            ),
    ),
  );
}

/// Creates a minimal GoRouter for screens that use context.goNamed/pushNamed.
GoRouter createTestRouter({
  required Widget home,
  AuthBloc? authBloc,
  CategoriesBloc? categoriesBloc,
  ProfileBloc? profileBloc,
  TasksBloc? tasksBloc,
  TaskBloc? taskBloc,
  NetworkBloc? networkBloc,
}) {
  final providers = <BlocProvider>[];
  if (authBloc != null) providers.add(BlocProvider<AuthBloc>.value(value: authBloc));
  if (categoriesBloc != null) providers.add(BlocProvider<CategoriesBloc>.value(value: categoriesBloc));
  if (profileBloc != null) providers.add(BlocProvider<ProfileBloc>.value(value: profileBloc));
  if (tasksBloc != null) providers.add(BlocProvider<TasksBloc>.value(value: tasksBloc));
  if (taskBloc != null) providers.add(BlocProvider<TaskBloc>.value(value: taskBloc));
  if (networkBloc != null) providers.add(BlocProvider<NetworkBloc>.value(value: networkBloc));

  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'landing',
        builder: (_, __) => providers.isEmpty ? home : MultiBlocProvider(providers: providers, child: home),
      ),
      GoRoute(path: '/login', name: 'logIn', builder: (_, __) => const SizedBox()),
      GoRoute(path: '/signup', name: 'signUp', builder: (_, __) => const SizedBox()),
      GoRoute(path: '/tasks', name: 'tasks', builder: (_, __) => const SizedBox()),
      GoRoute(path: '/profile', name: 'profile', builder: (_, __) => const SizedBox()),
      GoRoute(path: '/categories', name: 'categories', builder: (_, __) => const SizedBox()),
      GoRoute(path: '/task_form', name: 'taskForm', builder: (_, __) => const SizedBox()),
    ],
  );
}
