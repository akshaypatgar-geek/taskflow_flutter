import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_task_response.freezed.dart';
part 'delete_task_response.g.dart';

@freezed
sealed class DeleteTaskResponse with _$DeleteTaskResponse {
  const factory DeleteTaskResponse({
    @JsonKey(name: 'id') required String taskId,
  }) = _DeleteTaskResponse;

  factory DeleteTaskResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteTaskResponseFromJson(json);
}