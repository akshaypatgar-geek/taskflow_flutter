import 'package:hive_ce/hive.dart';
import 'package:taskflowapp/features/profile/data/model/user_details_model/user_details_model.dart';
import 'package:taskflowapp/features/profile/data/datasources/local/model/user_details_hive.dart';

class UserProfileLocalRepository {
  final Box<UserDetailsHive> userBox;

  UserProfileLocalRepository({required this.userBox});

  static const _currentUserKey = 'current_user';

  UserDetailsModel? getCachedUser() {
    final cached = userBox.get(_currentUserKey);
    if (cached == null) return null;
    return UserDetailsModel(
      userId: cached.userId,
      userName: cached.userName,
      userEmail: cached.userEmail,
      userStatus: cached.userStatus,
      profilePicture: cached.profilePicture,
    );
  }

  Future<void> cacheUser(UserDetailsModel user) async {
    final hiveModel = UserDetailsHive(
      userId: user.userId,
      userName: user.userName,
      userEmail: user.userEmail,
      userStatus: user.userStatus,
      profilePicture: user.profilePicture,
    );
    await userBox.put(_currentUserKey, hiveModel);
  }

  Future<void> clearCachedUser() async {
    await userBox.delete(_currentUserKey);
  }
}
