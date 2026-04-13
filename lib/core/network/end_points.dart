class EndPoints {
  static String refreshToken = '/auth/refresh';
  static String login = '/auth/login';
  static String signUp = '/users/register';
  static String updateUser = '/users';
  static String listTasks = '/tasks';
  static String taskDetails(String taskId) => '/tasks/$taskId';
  static String listCategories = '/categories';
  static String createCategory = '/categories/create';
  static String createTask = '/tasks/create';
  static String updateTask ='/tasks';
  static String deleteTask(String taskId)=>'/tasks/$taskId';
  static String getUserDetails = '/users/profile';
  static String categoryDetails(String id) => '/categories/$id';
  static String subscribeToTopic = '/firebase/subscribe';
}