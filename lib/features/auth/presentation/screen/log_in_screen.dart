import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/surface_card.dart';
import '../bloc/auth/auth_bloc.dart';
import '../widget/log_in_input.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
   
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to your account',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                SurfaceCard(
                  child: Column(
                    children: [
                      LogInInput(
                        emailController: emailController,
                        passwordController: passwordController,
                      ),
                      const SizedBox(height: 24),
                      BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthAuthenticated) {
                            context.goNamed('tasks');
                          } else if (state is AuthLoginFailed) {
                            SnackbarHelper.showErrorMessage(
                              context: context,
                              message: state.errorMessage,
                            );
                          }
                        },
                        builder: (context, state) {
                          return PrimaryButton(
                            label: 'Log In',
                            isLoading: state is AuthLoggingIn,
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                AuthInitiateLogInEvent(
                                  email: emailController.text.toLowerCase().trim(),
                                  password: passwordController.text.trim(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => context.pushNamed('signUp'),
                    child: Text(
                      'Sign Up instead',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    ),
  ),
);
  }
}