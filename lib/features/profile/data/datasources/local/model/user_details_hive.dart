

import 'package:hive_ce/hive.dart';

part 'user_details_hive.g.dart';

@HiveType(typeId: 1)
class UserDetailsHive {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String? userName;

  @HiveField(2)
  String userEmail;

  @HiveField(3)
  String? userStatus;

  @HiveField(4)
  String? profilePicture;

  UserDetailsHive({
    required this.userId,
    this.userName,
    required this.userEmail,
    this.userStatus,
    this.profilePicture
  });

  factory UserDetailsHive.fromJson(Map<String, dynamic> json) {
    return UserDetailsHive(
      userId: json['id'] as String,
      userName: json['name'] as String?,
      userEmail: json['email'] as String,
      userStatus: json['status'] as String?,
      profilePicture: json['profilePicture'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userStatus': userStatus,
      'profilePicture': profilePicture,
    };
  }
}