import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/core/offline/repository/offline_request_repository.dart';
import 'package:taskflowapp/features/auth/presentation/bloc/auth/auth_bloc.dart';
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
    // context.read<ProfileBloc>().add(GetProfileDetailsEvent());
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
                    } else if (state is UserProfileFailedState) {
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
                                  color: Colors.white,
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

  // Widget _buildProfileOptions() {
  //   return Column(
  //     children: [
  //       ListTile(title: Text('FAQ'), onTap: () {}),
  //       ListTile(title: Text('Terms & Conditions'), onTap: () {}),
  //       BlocConsumer<AuthBloc, AuthState>(
  //         listener: (context, state) {
  //           log("state listened :");
  //           if (state is AuthUnauthenticated) {
  //             print("unauthenticated");
  //             context.goNamed('landing');
  //           }
  //         },
  //         builder: (context, state) {
  //           return ListTile(
  //             title: Text('Logout'),
  //             onTap: () {
  //               context.read<AuthBloc>().add(UserLogOutEvent());
  //               context.read<AuthBloc>().add(CheckSessionEvent());
  //             },
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey.shade900),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.grey.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RepositoryProvider(
        create: (context) => ProfileRepository(
          client: context.read<DioClient>(),
          offlineRepository: context.read<OfflineRequestRepository>(),
        ),
        child: BlocProvider(
          create: (context) =>
              ProfileBloc(repository: context.read<ProfileRepository>())
                ..add(GetProfileDetailsEvent()),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoadingState || state is ProfileInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is UserDetailsReceivedState) {
                final user = state.userDetails;
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage:
                            user.profilePicture != null &&
                                user.profilePicture!.isNotEmpty
                            ? NetworkImage(user.profilePicture!)
                            : null,
                        child: user.profilePicture == null
                            ? Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey.shade700,
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Username with edit
                      GestureDetector(
                        onTap: () => _showUpdateNameSheet(
                          currentName: user.userName ?? '',
                          profileBloc: context.read<ProfileBloc>(),
                        ),
                        child: Text(
                          user.userName ?? 'Add Name',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Options Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
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
                                color: Colors.grey.shade700,
                              ),
                              title: Text(
                                'FAQ',
                                style: TextStyle(color: Colors.grey.shade900),
                              ),
                              onTap: () {},
                            ),
                            Divider(height: 1),
                            ListTile(
                              leading: Icon(
                                Icons.description_outlined,
                                color: Colors.grey.shade700,
                              ),
                              title: Text(
                                'Terms & Conditions',
                                style: TextStyle(color: Colors.grey.shade900),
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
                                    color: Colors.red.shade400,
                                  ),
                                  title: Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: Colors.red.shade400,
                                    ),
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog.adaptive(
                                        title: Text("Logout"),
                                        content: Text(
                                          "All of your to be synced data will be lost. Are you sure you want to Logout?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              ctx.pop();
                                            },
                                            child: Text("No, Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context.read<AuthBloc>().add(
                                                UserLogOutEvent(),
                                              );
                                              context.read<AuthBloc>().add(
                                                CheckSessionEvent(),
                                              );
                                            },
                                            child: Text(
                                              "Logout",
                                              style: TextStyle(
                                                color: Colors.redAccent,
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
