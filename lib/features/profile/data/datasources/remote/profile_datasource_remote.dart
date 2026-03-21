

import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/features/profile/data/datasources/profile_datasource_interface.dart';
import 'package:taskflowapp/features/profile/data/model/user_details_model/user_details_model.dart';

import '../../../../../core/network/end_points.dart';

class ProfileDatasourceRemoteImpl implements ProfileDatasourceRemote{
  final DioClient dioClient;

  ProfileDatasourceRemoteImpl({required this.dioClient});
  @override
  Future<UserDetailsModel> getUserDetails() async{
    try {
      final response = await dioClient.getRequest<Map<String, dynamic>>(
        endpoint: EndPoints.getUserDetails,
      );
      return UserDetailsModel.fromJson(response!);
    }  catch (e) {
      rethrow;
    }
    
  }
  
  @override
  Future<UserDetailsModel> updateUserDetails({String? name, String? profilePicture})async {
   try {
    final response = await dioClient.patchRequest<Map<String, dynamic>>(
        endpoint: EndPoints.updateUser,
        body: {
          'name': name,
          'profilePicture': profilePicture,
        },
      );
      return UserDetailsModel.fromJson(response!);
   } catch (e) {
    rethrow;
   }
  }

  
}