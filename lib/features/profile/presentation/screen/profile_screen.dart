import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/core/offline/repository/offline_request_repository.dart';
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

  void _showUpdateNameSheet({required String currentName,required ProfileBloc profileBloc }) {
  _nameController.text = currentName;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return BlocProvider.value(
        value: profileBloc, // Provide the existing bloc
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
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
              SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 12),
              BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is UserDetailsReceivedState) {
                    Navigator.pop(sheetContext); // Close bottom sheet
                  } else if (state is UserProfileFailedState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
                builder: (context, state) {
                  final isUpdating = state is UpdateUserDetailsLoadingState;

                  return ElevatedButton(
                    onPressed: isUpdating
                        ? null
                        : () {
                            final newName = _nameController.text.trim();
                            if (newName.isNotEmpty) {
                              context
                                  .read<ProfileBloc>()
                                  .add(UpdateProfileEvent(name: newName));
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
                  );
                },
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      );
    },
  );
}

  Widget _buildProfileOptions() {
    return Column(
      children: [
        ListTile(
          title: Text('FAQ'),
          onTap: () {},
        ),
        ListTile(
          title: Text('Terms & Conditions'),
          onTap: () {},
        ),
        ListTile(
          title: Text('Logout'),
          onTap: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: RepositoryProvider(
        create: (context) => ProfileRepository(client: context.read<DioClient>(),
        offlineRepository: context.read<OfflineRequestRepository>()),
        child: BlocProvider(
          create: (context) => ProfileBloc(repository: context.read<ProfileRepository>())..add(GetProfileDetailsEvent()),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoadingState || state is ProfileInitial) {
                return const Center(child: CircularProgressIndicator());
              }
          
              if (state is UserDetailsReceivedState) {
                final user = state.userDetails;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 24),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: user.profilePicture != null &&
                                user.profilePicture!.isNotEmpty
                            ? NetworkImage(user.profilePicture!)
                            : null,
                        child: user.profilePicture == null
                            ? Icon(Icons.person, size: 50)
                            : null,
                      ),
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _showUpdateNameSheet(currentName: user.userName ?? '',
                        profileBloc: context.read<ProfileBloc>() ),
                        child: Text(
                          user.userName ?? 'Add name',
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 32),
                      _buildProfileOptions(),
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