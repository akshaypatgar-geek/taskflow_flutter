import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/utils/constants.dart';
import 'package:taskflowapp/core/widgets/app_loading_indicator.dart';
import 'package:taskflowapp/core/widgets/confirm_dialog.dart';
import 'package:taskflowapp/core/widgets/primary_button.dart';
import 'package:taskflowapp/core/widgets/surface_card.dart';
import 'package:taskflowapp/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:taskflowapp/features/profile/domain/entities/user_details/user_details.dart';
import '../bloc/profile/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _showUpdateNameSheet({
    required String currentName,
    required ProfileBloc profileBloc,
  }) {
    _nameController.text = currentName;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: profileBloc,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
              top: 16,
              left: 16,
              right: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               Text(
                  'Update Name',
                  style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 12),
                BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is UserDetailsReceivedState) {
                      sheetContext.pop();
                    } else if (state is UpdateUserDetailsFailedState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return PrimaryButton(
                      label: 'Submit',
                      isLoading: state is UpdateUserDetailsLoadingState,
                      onPressed: () {
                        final newName = _nameController.text.trim();
                        if (newName.isNotEmpty) {
                          context.read<ProfileBloc>().add(
                                UpdateProfileEvent(name: newName),
                              );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
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
        leading: Semantics(
          label: 'Back',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
            color: colorScheme.onSurface,
          ),
        ),
        title: Text(
          'Profile',
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
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
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
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
                                size: 50,
                                color: colorScheme.outlineVariant,
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),

                      
                      GestureDetector(
                        onTap: () => _showUpdateNameSheet(
                          currentName: user.userName ?? '',
                          profileBloc: context.read<ProfileBloc>(),
                        ),
                        child: Text(
                          user.userName ?? 'Add Name',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      SurfaceCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            Semantics(
                              label: 'FAQ',
                              button: true,
                              child: ListTile(
                                leading: Icon(
                                  Icons.help_outline,
                                  color: colorScheme.outlineVariant,
                                ),
                                title: Text(
                                  'FAQ',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                onTap: () {},
                              ),
                            ),
                            const Divider(height: 1),
                            Semantics(
                              label: 'Categories',
                              button: true,
                              child: ListTile(
                                leading: Icon(
                                  Icons.category_outlined,
                                  color: colorScheme.outlineVariant,
                                ),
                                title: Text(
                                  'Categories',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                onTap: () => context.pushNamed('categories'),
                              ),
                            ),
                            const Divider(height: 1),
                            Semantics(
                              label: 'Terms & Conditions',
                              button: true,
                              child: ListTile(
                                leading: Icon(
                                  Icons.description_outlined,
                                  color: colorScheme.outlineVariant,
                                ),
                                title: Text(
                                  'Terms & Conditions',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                onTap: () {},
                              ),
                            ),
                           const Divider(height: 1),
                            BlocConsumer<AuthBloc, AuthState>(
                              listener: (context, state) {
                                if (state is AuthUnauthenticated) {
                                  context.goNamed('landing');
                                }
                              },
                              builder: (context, state) {
                                return Semantics(
                                  label: 'Logout',
                                  button: true,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.logout,
                                      color: colorScheme.error,
                                    ),
                                    title: Text(
                                      'Logout',
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: colorScheme.error,
                                      ),
                                    ),
                                    onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => ConfirmDialog(
                                        title: 'Logout',
                                        message:
                                            'All of your to be synced data will be lost. Are you sure you want to Logout?',
                                        confirmLabel: 'Logout',
                                        cancelLabel: 'No, Cancel',
                                        isDestructive: true,
                                        onConfirm: () {
                                          context.read<AuthBloc>().add(
                                                UserLogOutEvent(),
                                              );
                                        },
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
                    ],
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
