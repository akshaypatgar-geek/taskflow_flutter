import 'package:freezed_annotation/freezed_annotation.dart';

import '../task_model/task_model.dart';

part 'list_tasks_response.freezed.dart';
part 'list_tasks_response.g.dart';

@freezed
sealed class ListTasksResponse with _$ListTasksResponse {
  const factory ListTasksResponse({
    required List<TaskModel> tasks,
     String? nextCursor,
    required bool hasNextPage,
  }) = _ListTasksResponse;

  factory ListTasksResponse.fromJson(Map<String, dynamic> json) =>
      _$ListTasksResponseFromJson(json);
}