import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/routes/router.dart';

import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../../core/widgets/surface_card.dart';
import '../bloc/auth/auth_bloc.dart';
import '../widget/log_in_input.dart';
import 'package:taskflowapp/core/theme/app_tokens.dart';
import 'package:taskflowapp/core/utils/constants.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
        child: ResponsiveContainer(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: AppTokens.s4xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.welcomeBack,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppTokens.sM),
                Text(
                  AppStrings.signInToAccount,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppTokens.s4xl),
                SurfaceCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        LogInInput(
                          emailController: emailController,
                          passwordController: passwordController,
                        ),
                        const SizedBox(height: AppTokens.sXxxl),
                        BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is AuthAuthenticated) {
                              context.goNamed(ScreenPaths.tasks.name);
                            } else if (state is AuthLoginFailed) {
                              SnackbarHelper.showErrorMessage(
                                context: context,
                                message: state.errorMessage,
                              );
                            }
                          },
                          buildWhen: (previous, current) {
                            if (previous is AuthLoggingIn &&
                                current is! AuthLoggingIn) {
                              return true;
                            } else if (current is AuthLoggingIn &&
                                previous is! AuthLoggingIn) {
                              return true;
                            }
                            return false;
                          },
                          builder: (context, state) {
                            return Semantics(
                              label: AppStrings.logIn,
                              tooltip: AppStrings.logIn,
                              button: true,
                              child: PrimaryButton(
                                label: AppStrings.logIn,
                                isLoading: state is AuthLoggingIn,
                                onPressed: () {
                                  if (!_formKey.currentState!.validate())
                                    return;
                                  context.read<AuthBloc>().add(
                                    AuthInitiateLogInEvent(
                                      email: emailController.text
                                          .toLowerCase()
                                          .trim(),
                                      password: passwordController.text.trim(),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppTokens.sXl),
                Center(
                  child: Semantics(
                    label: AppStrings.signUpInstead,
                    tooltip: AppStrings.signUpInstead,
                    button: true,
                    child: TextButton(
                      onPressed: () =>
                          context.pushNamed(ScreenPaths.signup.name),
                      child: Text(
                        AppStrings.signUpInstead,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
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
