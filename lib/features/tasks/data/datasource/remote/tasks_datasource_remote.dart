import 'package:taskflowapp/features/tasks/data/model/list_tasks_response/list_tasks_response.dart';
import 'package:taskflowapp/core/utils/constants.dart';

abstract interface class TasksDatasourceRemote {
  Future<ListTasksResponse> listUserTasks ({
        String? searchKey,
  String? status,
  String sortBy = 'date',
  String sortOrder = 'desc',
  String? cursor,
  int limit = TaskDefaults.pageSize,
  String? categoryId
  });
}