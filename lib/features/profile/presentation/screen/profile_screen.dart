import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/injection/injection.dart';
import 'package:taskflowapp/core/routes/router.dart';
import 'package:taskflowapp/core/utils/constants.dart';
import 'package:taskflowapp/core/widgets/app_loading_indicator.dart';
import 'package:taskflowapp/core/widgets/confirm_dialog.dart';
import 'package:taskflowapp/core/widgets/primary_button.dart';
import 'package:taskflowapp/core/widgets/responsive_container.dart';
import 'package:taskflowapp/core/widgets/surface_card.dart';
import 'package:taskflowapp/core/utils/snackbar_helper.dart';
import 'package:taskflowapp/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:taskflowapp/features/profile/domain/entities/user_details/user_details.dart';
import '../bloc/profile/profile_bloc.dart';
import 'package:taskflowapp/core/theme/app_tokens.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  

  void _showUpdateNameSheet({
    required String currentName,
    required ProfileBloc profileBloc,
  }) {
    _nameController.text = currentName;
    final _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTokens.rL)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: profileBloc,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + AppTokens.sXl,
              top: AppTokens.sXl,
              left: AppTokens.sXl,
              right: AppTokens.sXl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               Text(
                  AppStrings.updateName,
                  style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTokens.sL),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _nameController,
                    maxLength: AppTokens.profileNameMaxLength,
                    decoration: const InputDecoration(
                      labelText: AppStrings.nameLabel,
                      counterText: '',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.nameRequired;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppTokens.sL),
                BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is UserDetailsReceivedState) {
                      sheetContext.pop();
                    } else if (state is UpdateUserDetailsFailedState) {
                      SnackbarHelper.showErrorMessage(
                        context: context,
                        message: state.errorMessage,
                      );
                    }
                  },
                  buildWhen: (previous, current) {
                    if ((previous is UpdateUserDetailsLoadingState &&
                            current is! UpdateUserDetailsLoadingState) ||
                        (current is UpdateUserDetailsLoadingState &&
                            previous is! UpdateUserDetailsLoadingState)) {
                      return true;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    return Semantics(
                      label: AppStrings.updateName,
                      tooltip: AppStrings.updateProfileTooltip,
                      button: true,
                      child: PrimaryButton(
                        label: AppStrings.submit,
                        isLoading: state is UpdateUserDetailsLoadingState,
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          final newName = _nameController.text.trim();
                          if (newName.isNotEmpty) {
                            context.read<ProfileBloc>().add(
                                  UpdateProfileEvent(name: newName),
                                );
                          }
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppTokens.sL),
              ],
            ),
          ),
        );
      },
    );
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
        leading: context.canPop()
            ? Semantics(
                label: AppStrings.back,
                tooltip: AppStrings.back,
                button: true,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: AppStrings.back,
                  onPressed: () => context.pop(),
                  color: colorScheme.onSurface,
                ),
              )
            : null,
        title: Text(
          AppStrings.profile,
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        buildWhen: (previous, current) {
          // Rebuild only when the underlying user data changes,
          // not on transient loading/failure states from the sheet.
          if (previous.runtimeType != current.runtimeType) return true;
          if (previous is UserDetailsReceivedState &&
              current is UserDetailsReceivedState) {
            return previous.userDetails != current.userDetails;
          }
          return false;
        },
        builder: (context, state) {
              if (state is ProfileLoadingState || state is ProfileInitial) {
                return const AppLoadingIndicator();
              }

              final UserDetails? maybeUser;
              if (state is UserDetailsReceivedState) {
                maybeUser = state.userDetails;
              } else if (state is UpdateUserDetailsLoadingState) {
                maybeUser = state.userDetails;
              } else if (state is UpdateUserDetailsFailedState) {
                maybeUser = state.userDetails;
              } else {
                maybeUser = null;
              }

              if (maybeUser case final UserDetails user) {
                return ResponsiveContainer(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTokens.s4xl,
                    ),
                    child: Column(
                    children: [
                      CircleAvatar(
                        radius: AppTokens.avatarRadius,
                        backgroundColor:
                            colorScheme.outline.withValues(alpha: 0.2),
                        backgroundImage:
                            user.profilePicture != null &&
                                user.profilePicture!.isNotEmpty
                            ? NetworkImage(user.profilePicture!)
                            : null,
                        child: user.profilePicture == null
                            ? Icon(
                                Icons.person,
                                size: AppTokens.avatarRadius,
                                color: colorScheme.outlineVariant,
                              )
                            : null,
                      ),
                      const SizedBox(height: AppTokens.sXl),

                      
                      GestureDetector(
                        onTap: () => _showUpdateNameSheet(
                          currentName: user.userName ?? '',
                          profileBloc: context.read<ProfileBloc>(),
                        ),
                        child: Text(
                          user.userName ?? AppStrings.addName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTokens.s4xl),

                      SurfaceCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            Semantics(
                              label: AppStrings.faq,
                              button: true,
                              child: ListTile(
                                leading: Icon(
                                  Icons.help_outline,
                                  color: colorScheme.outlineVariant,
                                ),
                                title: Text(
                                  AppStrings.faq,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                onTap: () {},
                              ),
                            ),
                            const Divider(height: 1),
                            Semantics(
                              label: AppStrings.categories,
                              button: true,
                              child: ListTile(
                                leading: Icon(
                                  Icons.category_outlined,
                                  color: colorScheme.outlineVariant,
                                ),
                                title: Text(
                                  AppStrings.categories,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                onTap: () => context.pushNamed(ScreenPaths.categories.name),
                              ),
                            ),
                            const Divider(height: 1),
                            Semantics(
                              label: AppStrings.termsAndConditions,
                              button: true,
                              child: ListTile(
                                leading: Icon(
                                  Icons.description_outlined,
                                  color: colorScheme.outlineVariant,
                                ),
                                title: Text(
                                  AppStrings.termsAndConditions,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                onTap: () {},
                              ),
                            ),
                            const Divider(height: 1),
                            BlocListener<AuthBloc, AuthState>(
                              listener: (context, state) {
                                if (state is AuthUnauthenticated) {
                                  context.goNamed(ScreenPaths.root.name);
                                }
                              },
                              child: Semantics(
                                label: AppStrings.logout,
                                button: true,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.logout,
                                    color: colorScheme.error,
                                  ),
                                  title: Text(
                                    AppStrings.logout,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.error,
                                    ),
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => ConfirmDialog(
                                        title: AppStrings.logout,
                                        message: AppStrings.logoutWarning,
                                        confirmLabel: AppStrings.logout,
                                        cancelLabel: AppStrings.noCancel,
                                        isDestructive: true,
                                        onConfirm: () {
                                          sl<TasksBloc>().add(ResetTasksEvent());
                                          context.read<AuthBloc>().add(
                                                UserLogOutEvent(),
                                              );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    ),
                  ),
                );
              }

              return const Center(child: Text(AppStrings.somethingWentWrong));
            },
        ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
