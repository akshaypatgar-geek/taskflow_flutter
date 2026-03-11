

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
}