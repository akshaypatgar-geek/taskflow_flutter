import 'package:hive_ce/hive.dart';
import 'package:taskflowapp/core/utils/constants.dart';
import 'package:taskflowapp/features/profile/data/model/user_details_model/user_details_model.dart';

import '../../../../../core/network/exceptions.dart';
import '../profile_datasource_local.dart';
import 'model/user_details_hive.dart';

class ProfileDatasourceLocalImpl implements ProfileDatasourceLocal{
  final Box<UserDetailsHive> userBox;

  ProfileDatasourceLocalImpl({required this.userBox});

  static const _currentUserKey = 'current_user';
  @override
  Future<UserDetailsModel> getUserDetails()async {
    
    final cachedUser = userBox.get(_currentUserKey);
    if(cachedUser == null) {
      throw const NotFoundException(AppStrings.userNotFound);
    }

    return UserDetailsModel(userId: cachedUser.userId, userEmail: cachedUser.userEmail, userName: cachedUser.userName, userStatus: cachedUser.userStatus, profilePicture: cachedUser.profilePicture);
  }
  
  @override
  Future<void> updateUserDetails({required UserDetailsModel userModel}) async{
  final user = UserDetailsHive.fromJson(userModel.toJson());
     await userBox.put(_currentUserKey, user);
  }
  
  
  
  

  
}