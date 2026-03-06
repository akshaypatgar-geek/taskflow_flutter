import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskflowapp/features/tasks/data/model/task/task.dart';

part 'task_mutation_response.freezed.dart';
part 'task_mutation_response.g.dart';

@freezed
sealed class TaskMutationResponse with _$TaskMutationResponse{
  const factory TaskMutationResponse({
    required Task task,
  }) = _TaskMutationResponse;

  factory TaskMutationResponse.fromJson(Map<String, dynamic>json) => _$TaskMutationResponseFromJson(json);
}