import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/auth/presentation/screen/landing_screen.dart' deferred as landing;
import '../../features/auth/presentation/screen/log_in_screen.dart' deferred as login;
import '../../features/auth/presentation/screen/sign_up_screen.dart' deferred as signup;
import '../utils/error_screen.dart';
import '../widgets/adaptive_nav_rail.dart';
import 'deferred_route_loader.dart';
import 'go_router_refresh_stream.dart';
import 'route_builders.dart' deferred as route_builders;

class ScreenPaths {
  static const root = (name: 'landing', path: '/');

  static const login = (name: 'logIn', path: '/login');

  static const signup = (name: 'signUp', path: '/signup');

  static const tasks = (name: 'tasks', path: '/tasks');

  static const taskForm = (name: 'taskForm', path: '/tasks/new');

  static const taskDetail = (name: 'taskDetail', path: '/tasks/:id');

  static const profile = (name: 'profile', path: '/profile');

  static const categories = (name: 'categories', path: '/categories');

  static const featureList = (name: 'featureList', path: '/feature-list');
}

class Routes {
  Routes(this.authBloc);

  final AuthBloc authBloc;

  late final GoRouter router = GoRouter(
        initialLocation: ScreenPaths.root.path,
        refreshListenable: GoRouterRefreshStream(authBloc.stream),
        errorBuilder: (context, state) => const ErrorScreen(),

        redirect: (context, state) {
          final authState = authBloc.state;
          final loggingIn =
              state.matchedLocation == ScreenPaths.login.path ||
              state.matchedLocation == ScreenPaths.signup.path;

          if (authState is AuthUnauthenticated) {
            return loggingIn ? null : ScreenPaths.login.path;
          }

          if (authState is AuthAuthenticated) {
            return (loggingIn || state.matchedLocation == ScreenPaths.root.path)
                ? ScreenPaths.tasks.path
                : null;
          }

          return null;
        },

        routes: [
          GoRoute(
            path: ScreenPaths.root.path,
            name: ScreenPaths.root.name,
            builder: (_, _) => DeferredRouteLoader(
              load: landing.loadLibrary,
              childBuilder: () => landing.LandingScreen(),
            ),
          ),
          GoRoute(
            path: ScreenPaths.login.path,
            name: ScreenPaths.login.name,
            builder: (_, _) => DeferredRouteLoader(
              load: login.loadLibrary,
              childBuilder: () => login.LogInScreen(),
            ),
          ),
          GoRoute(
            path: ScreenPaths.signup.path,
            name: ScreenPaths.signup.name,
            builder: (_, _) => DeferredRouteLoader(
              load: signup.loadLibrary,
              childBuilder: () => signup.SignUpScreen(),
            ),
          ),
          GoRoute(
            path: ScreenPaths.taskForm.path,
            name: ScreenPaths.taskForm.name,
            builder: (context, state) => DeferredRouteLoader(
              load: route_builders.loadLibrary,
              childBuilder: () => route_builders.TaskFormRouteBuilder.build(context, state),
            ),
          ),
          GoRoute(
            path: ScreenPaths.taskDetail.path,
            name: ScreenPaths.taskDetail.name,
            builder: (context, state) => DeferredRouteLoader(
              load: route_builders.loadLibrary,
              childBuilder: () => route_builders.TaskDetailRouteBuilder.build(context, state),
            ),
          ),
          ShellRoute(
            builder: (context, state, child) {
              final loc = state.matchedLocation;
              final selectedIndex = loc.startsWith(ScreenPaths.profile.path)
                  ? 1
                  : loc.startsWith(ScreenPaths.categories.path)
                      ? 2
                      : 0;

              return AdaptiveNavRail(
                selectedIndex: selectedIndex,
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: ScreenPaths.tasks.path,
                name: ScreenPaths.tasks.name,
                builder: (context, state) => DeferredRouteLoader(
                  load: route_builders.loadLibrary,
                  childBuilder: () => route_builders.TasksRouteBuilder.build(context, state),
                ),
              ),
              GoRoute(
                path: ScreenPaths.profile.path,
                name: ScreenPaths.profile.name,
                builder: (context, state) => DeferredRouteLoader(
                  load: route_builders.loadLibrary,
                  childBuilder: () => route_builders.ProfileRouteBuilder.build(context, state),
                ),
              ),
              GoRoute(
                path: ScreenPaths.featureList.path,
                name: ScreenPaths.featureList.name,
                builder: (context, state) => DeferredRouteLoader(
                  load: route_builders.loadLibrary,
                  childBuilder: () => route_builders.FeatureListRouteBuilder.build(context, state),
                ),
              ),
              GoRoute(
                path: ScreenPaths.categories.path,
                name: ScreenPaths.categories.name,
                builder: (context, state) => DeferredRouteLoader(
                  load: route_builders.loadLibrary,
                  childBuilder: () => route_builders.CategoriesRouteBuilder.build(context, state),
                ),
              ),
            ],
          ),
        ],
      );
}
