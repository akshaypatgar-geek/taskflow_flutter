import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:taskflowapp/features/profile/data/model/user_details/user_details.dart';
import 'package:taskflowapp/features/profile/local/model/user_details_hive.dart';
import 'package:taskflowapp/features/profile/local/user_profile_local_repository/user_profile_local_repository.dart';
import '../../data/repository/profile_repository.dart';
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
      shape: RoundedRectangleBorder(
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 12),
                BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is UserDetailsReceivedState) {
                      Navigator.pop(sheetContext);
                    } else if (state is UpdateUserDetailsFailedState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage)),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isUpdating = state is UpdateUserDetailsLoadingState;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isUpdating
                            ? null
                            : () {
                                final newName = _nameController.text.trim();
                                if (newName.isNotEmpty) {
                                  context.read<ProfileBloc>().add(
                                    UpdateProfileEvent(name: newName),
                                  );
                                }
                              },
                        child: isUpdating
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Theme.of(sheetContext)
                                      .colorScheme
                                      .onPrimary,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text('Submit'),
                      ),
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
      body: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (_) => UserProfileLocalRepository(
              userBox: Hive.box<UserDetailsHive>('userBox'),
            ),
          ),
          RepositoryProvider(
            create: (context) => ProfileRepository(
              client: context.read<DioClient>(),
              localRepository: context.read<UserProfileLocalRepository>(),
            ),
          ),
        ],
        child: BlocProvider(
          create: (context) => ProfileBloc(
            repository: context.read<ProfileRepository>(),
            localRepository: context.read<UserProfileLocalRepository>(),
          )..add(GetProfileDetailsEvent()),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoadingState || state is ProfileInitial) {
                return const Center(child: CircularProgressIndicator());
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

                      
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.help_outline,
                                color: colorScheme.outlineVariant,
                              ),
                              title: Text(
                                'FAQ',
                                style: TextStyle(color: colorScheme.onSurface),
                              ),
                              onTap: () {},
                            ),
                            Divider(height: 1),
                            ListTile(
                              leading: Icon(
                                Icons.description_outlined,
                                color: colorScheme.outlineVariant,
                              ),
                              title: Text(
                                'Terms & Conditions',
                                style: TextStyle(color: colorScheme.onSurface),
                              ),
                              onTap: () {},
                            ),
                            Divider(height: 1),
                            BlocConsumer<AuthBloc, AuthState>(
                              listener: (context, state) {
                                if (state is AuthUnauthenticated) {
                                  context.goNamed('landing');
                                }
                              },
                              builder: (context, state) {
                                return ListTile(
                                  leading: Icon(
                                    Icons.logout,
                                    color: colorScheme.error,
                                  ),
                                  title: Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: colorScheme.error,
                                    ),
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog.adaptive(
                                        title: const Text('Logout'),
                                        content: const Text(
                                          'All of your to be synced data will be lost. Are you sure you want to Logout?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              ctx.pop();
                                            },
                                            child: const Text('No, Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context.read<AuthBloc>().add(
                                                UserLogOutEvent(),
                                              );
                                            },
                                            child: Text(
                                              'Logout',
                                              style: TextStyle(
                                                color: colorScheme.error,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
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

              return Center(child: Text('Something went wrong.'));
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
