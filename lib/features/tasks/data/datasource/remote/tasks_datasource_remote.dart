import 'package:taskflowapp/features/tasks/data/model/list_tasks_response/list_tasks_response.dart';

abstract interface class TasksDatasourceRemote {
  Future<ListTasksResponse> listUserTasks ({
        String? searchKey,
  String? status,
  String sortBy = 'date',
  String sortOrder = 'desc',
  String? cursor,
  int limit = 10,
  String? categoryId
  });
}