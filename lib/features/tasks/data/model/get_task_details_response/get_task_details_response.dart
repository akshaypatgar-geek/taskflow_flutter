import 'package:freezed_annotation/freezed_annotation.dart';

import '../task/task.dart';

part 'get_task_details_response.freezed.dart';
part 'get_task_details_response.g.dart';

@freezed
sealed class GetTaskDetailsResponse with _$GetTaskDetailsResponse{
  const factory GetTaskDetailsResponse({
    required Task task
  }) = _GetTaskDetailsResponse;
  factory GetTaskDetailsResponse.fromJson(Map<String,dynamic>json) =>_$GetTaskDetailsResponseFromJson(json);
}