
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

part 'offline_request_hive.g.dart';

@HiveType(typeId: 4)
class OfflineRequestHive {
  @HiveField(0)
  String method;

  @HiveField(1)
  String endPoint;

  @HiveField(2)
  Map<String, dynamic>? body;

  @HiveField(3)
  Map<String, dynamic>? queryParameters;

  @HiveField(5)
  String createdAt;

  OfflineRequestHive({
    required this.method,
    required this.endPoint,
    this.body, this.queryParameters,
    required this.createdAt
  });
}