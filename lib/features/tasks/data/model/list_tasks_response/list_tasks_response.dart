import 'package:freezed_annotation/freezed_annotation.dart';

import '../task/task.dart';

part 'list_tasks_response.freezed.dart';
part 'list_tasks_response.g.dart';

@freezed
sealed class ListTasksResponse with _$ListTasksResponse {
  const factory ListTasksResponse({
    required List<Task> tasks,
     String? nextCursor,
    required bool hasNextPage,
  }) = _ListTasksResponse;

  factory ListTasksResponse.fromJson(Map<String, dynamic> json) =>
      _$ListTasksResponseFromJson(json);
}