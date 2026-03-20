import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/auth/presentation/screen/landing_screen.dart' deferred as landing;
import '../../features/auth/presentation/screen/log_in_screen.dart' deferred as login;
import '../../features/auth/presentation/screen/sign_up_screen.dart' deferred as signup;
import '../utils/error_screen.dart';
import 'deferred_route_loader.dart';
import 'go_router_refresh_stream.dart';
import 'route_builders.dart' deferred as route_builders;

class Routes {
  Routes(this.authBloc);

  final AuthBloc authBloc;

  GoRouter get router => GoRouter(
        initialLocation: '/',
        refreshListenable: GoRouterRefreshStream(authBloc.stream),
        errorBuilder: (context, state) => const ErrorScreen(),

        redirect: (context, state) {
          final authState = authBloc.state;
          final loggingIn =
              state.matchedLocation == '/login' ||
              state.matchedLocation == '/signup';

          if (authState is AuthUnauthenticated) {
            return loggingIn ? null : '/login';
          }

          if (authState is AuthAuthenticated) {
            return (loggingIn || state.matchedLocation == '/')
                ? '/tasks'
                : null;
          }

          return null;
        },

        routes: [
          GoRoute(
            path: '/',
            name: 'landing',
            builder: (_, _) => DeferredRouteLoader(
              load: landing.loadLibrary,
              childBuilder: () => landing.LandingScreen(),
            ),
          ),
          GoRoute(
            path: '/login',
            name: 'logIn',
            builder: (_, _) => DeferredRouteLoader(
              load: login.loadLibrary,
              childBuilder: () => login.LogInScreen(),
            ),
          ),
          GoRoute(
            path: '/signup',
            name: 'signUp',
            builder: (_, _) => DeferredRouteLoader(
              load: signup.loadLibrary,
              childBuilder: () => signup.SignUpScreen(),
            ),
          ),
          GoRoute(
            path: '/tasks',
            name: 'tasks',
            builder: (context, state) => DeferredRouteLoader(
              load: route_builders.loadLibrary,
              childBuilder: () => route_builders.TasksRouteBuilder.build(context, state),
            ),
          ),
          GoRoute(
            path: '/task_form',
            name: 'taskForm',
            builder: (context, state) => DeferredRouteLoader(
              load: route_builders.loadLibrary,
              childBuilder: () => route_builders.TaskFormRouteBuilder.build(context, state),
            ),
          ),
          GoRoute(
            path: '/task/:id',
            name: 'taskDetail',
            builder: (context, state) => DeferredRouteLoader(
              load: route_builders.loadLibrary,
              childBuilder: () => route_builders.TaskDetailRouteBuilder.build(context, state),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => DeferredRouteLoader(
              load: route_builders.loadLibrary,
              childBuilder: () => route_builders.ProfileRouteBuilder.build(context, state),
            ),
          ),
          GoRoute(
            path: '/categories',
            name: 'categories',
            builder: (context, state) => DeferredRouteLoader(
              load: route_builders.loadLibrary,
              childBuilder: () => route_builders.CategoriesRouteBuilder.build(context, state),
            ),
          ),
        ],
      );
}
