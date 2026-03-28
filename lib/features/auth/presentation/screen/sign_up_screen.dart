import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/routes/router.dart';
import 'package:taskflowapp/core/utils/snackbar_helper.dart';
import 'package:taskflowapp/core/widgets/primary_button.dart';
import 'package:taskflowapp/core/widgets/responsive_container.dart';
import 'package:taskflowapp/core/widgets/surface_card.dart';
import 'package:taskflowapp/features/auth/presentation/bloc/auth/auth_bloc.dart';

import '../widget/log_in_input.dart';
import 'package:taskflowapp/core/theme/app_tokens.dart';
import 'package:taskflowapp/core/utils/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        leading: Semantics(
          label: AppStrings.back,
          tooltip: AppStrings.back,
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: AppStrings.back,
            onPressed: () => context.pop(),
            color: colorScheme.onSurface,
          ),
        ),
        title: Text(
          AppStrings.createAccount,
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: AppTokens.s4xl),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: ResponsiveContainer(
                  alignment: Alignment.center,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppStrings.setupAccount,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppTokens.sM),
                        Text(
                          AppStrings.enterEmailAndPassword,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppTokens.s4xl),
                        SurfaceCard(
                          child: Column(
                            children: [
                              LogInInput(
                                emailController: emailController,
                                passwordController: passwordController,
                              ),
                              const SizedBox(height: AppTokens.sXxxl),
                              BlocConsumer<AuthBloc, AuthState>(
                                listener: (context, state) {
                                  if (state is SignUpFailed) {
                                    SnackbarHelper.showErrorMessage(
                                      context: context,
                                      message: state.errorMessage,
                                    );
                                  } else if (state is SignUpSuccess) {
                                    context.goNamed(ScreenPaths.login.name);
                                  }
                                },
                                buildWhen: (previous, current) {
                                  if ((previous is AuthLoggingIn &&
                                          current is! AuthLoggingIn) ||
                                      (current is AuthLoggingIn &&
                                          previous is! AuthLoggingIn)) {
                                    return true;
                                  }
                                  return false;
                                },
                                builder: (context, state) {
                                  return Semantics(
                                    label: AppStrings.signUp,
                                    tooltip: AppStrings.signUp,
                                    button: true,
                                    child: PrimaryButton(
                                      label: AppStrings.signUp,
                                      isLoading: state is AuthLoggingIn,
                                      onPressed: () {
                                        if (!_formKey.currentState!.validate()) {
                                          return;
                                        }
                                        context.read<AuthBloc>().add(
                                              InitiateSignUpEvent(
                                                email: emailController.text
                                                    .toLowerCase()
                                                    .trim(),
                                                password: passwordController.text
                                                    .trim(),
                                              ),
                                            );
                                      },
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: AppTokens.s4xl),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
