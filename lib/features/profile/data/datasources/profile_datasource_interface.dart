import 'package:taskflowapp/features/profile/data/model/user_details_model/user_details_model.dart';

abstract interface class ProfileDatasourceRemote {
  Future<UserDetailsModel> getUserDetails();

  Future<UserDetailsModel> updateUserDetails({
    String? name,
    String? profilePicture,
  });
}
