/// Centralized error and success messages.
abstract final class AppStrings {
  AppStrings._();

  // --- App / common ---
  static const String appName = 'Taskflow';
  static const String retry = 'Retry';
  static const String all = 'All';
  static const String open = 'Open';
  static const String inProgress = 'In Progress';
  static const String completed = 'Completed';
  static const String back = 'Back';
  static const String cancel = 'Cancel';
  static const String submit = 'Submit';

  // --- Validation errors ---
  static const String emailRequired = 'Email required';
  static const String invalidEmailFormat = 'Invalid email format';
  static const String passwordRequired = 'Password cannot be empty';
  static const String passwordTooShort = 'Password too short';
  static const String titleRequired = 'Title required';
  static const String titleTooLong = 'Title must be at most 50 characters';
  static const int taskTitleMaxLength = 50;
  static const String editTitle = 'Edit title';
  static const String titleCannotBeEmpty = 'Title can not be empty';
  static const String nameRequired = 'Name required';
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String nameLabel = 'Name';
  static const String titleLabel = 'Title';
  static const String statusLabel = 'Status';
  static const String categoryLabel = 'Category';
  static const String priorityLabel = 'Priority';
  static const String searchTasksHint = 'Search tasks...';

  // --- Success messages ---
  static const String taskDeleted = 'Task deleted';
  static const String taskDetailsUpdated = 'Task details updated';
  static String taskRemovedAfterSync(String taskTitle) =>
      'Task "$taskTitle" was deleted on server and removed locally.';

  static String taskCreated(String taskTitle) => 'Task $taskTitle created';

  // --- Error messages ---
  static const String connectionError = 'Connection error. Please try again.';
  static const String networkErrorOccurred = 'Network error occurred';
  static const String somethingWentWrong = 'Something went wrong.';
  static const String serverErrorOccurred = 'Server error occurred';
  static const String somethingWrongTryAgainLater =
      'Something wrong. Please try again later.';
  static const String resourceNotFound = 'Resource not found';
  static const String resourceAlreadyExists = 'Resource already exists';
  static const String invalidCredentials = 'Invalid credentials';
  static const String unableToLoadTasks = 'Unable to load tasks.';
  static const String noCategoriesYet =
      'No categories yet. Tap + to create one.';
  static const String genericError = 'Error';
  static const String failedToLoad = 'Failed to load';
  static const String pageNotFound = 'Page Not Found';
  static const String notFoundCode = '404';
  static const String goHome = 'Go Home';
  static const String pageNotFoundMessage =
      'The page you are looking for does not exist.';

  // --- Auth screens ---
  static const String welcomeBack = 'Welcome back';
  static const String signInToAccount = 'Sign in to your account';
  static const String logIn = 'Log In';
  static const String signUp = 'Sign Up';
  static const String signUpInstead = 'Sign Up instead';
  static const String createAccount = 'Create Account';
  static const String setupAccount = 'Setup Your account';
  static const String enterEmailAndPassword = 'Enter your email and password';

  // --- Tasks screens ---
  static const String taskFlowTitle = 'TaskFlow';
  static const String sortTasks = 'Sort tasks';
  static const String sortByPriority = 'Sort by Priority';
  static const String latestOnTop = 'Latest on top';
  static const String networkOnline = 'Network status: online';
  static const String networkOffline = 'Network status: offline';
  static const String noInternetConnection = 'No internet connection';
  static const String addNewTask = 'Add new task';
  static const String openProfile = 'Open profile';
  static const String taskDetailsTitle = 'Task Details';
  static const String activityTitle = 'Activity';
  static const String createdPrefix = 'Created: ';
  static const String lastUpdatedPrefix = 'Last Updated: ';
  static const String updateTask = 'Update Task';
  static const String deleteTask = 'Delete task';
  static const String deleteTaskQuestion = 'Delete Task?';
  static const String deleteTaskWarning =
      'This task will be removed. This action cannot be undone.';
  static const String noCancel = 'No, Cancel';
  static const String createTask = 'Create Task';
  static const String updateTaskTitle = 'Update Task';
  static const String createTaskTitle = 'Create Task';
  static const String tasks = 'Tasks';

  // --- Categories / profile ---
  static const String categories = 'Categories';
  static const String createCategory = 'Create Category';
  static const String faq = 'FAQ';
  static const String theme = 'Theme';
  static const String systemThemeLabel = 'System';
  static const String lightThemeLabel = 'Light';
  static const String darkThemeLabel = 'Dark';
  static const String termsAndConditions = 'Terms & Conditions';
  static const String featureList = 'Feature List';
  static const String featureTaskManagementTitle =
      'Task creation and management';
  static const String featureTaskManagementDescription =
      'Create tasks, update titles, priorities, and statuses, and manage task details.';
  static const String featureRealtimeSyncTitle = 'WebSocket real-time sync';
  static const String featureRealtimeSyncDescription =
      'Task updates are synced in real time across devices using WebSocket events.';
  static const String featureOfflineTitle = 'Offline support';
  static const String featureOfflineDescription =
      'View tasks while offline and continue creating/updating tasks with sync when online.';
  static const String logout = 'Logout';
  static const String logoutTitle = 'Logout';
  static const String logoutWarning =
      'All of your to be synced data will be lost. Are you sure you want to Logout?';
  static const String profile = 'Profile';
  static const String updateName = 'Update Name';
  static const String addName = 'Add Name';
  static const String updateProfileTooltip = 'Update profile';
  static const String updateTaskTooltip = 'Update task';
  static const String createCategoryTooltip = 'Create category';

  // --- Legacy ---
  static const String userNotFound = 'User Not Found';

  // --- Legacy ---
  static const String loadingstate = 'Loading';
  static const String errorState = 'Error';
  static const String defaultState = 'default';
}

/// Centralized literals for task filters/sorting used across UI/data layers.
abstract final class TaskLiterals {
  TaskLiterals._();

  static const String statusAll = 'all';
  static const String statusOpen = 'OPEN';
  static const String statusInProgress = 'IN_PROGRESS';
  static const String statusCompleted = 'COMPLETED';

  static const String sortByDate = 'date';
  static const String sortByPriority = 'priority';
  static const String sortOrderDesc = 'desc';
}

/// Centralized keys for task listing query params.
abstract final class TaskQueryKeys {
  TaskQueryKeys._();

  static const String searchKey = 'searchKey';
  static const String status = 'status';
  static const String cursor = 'cursor';
  static const String categoryId = 'categoryId';
  static const String sortBy = 'sortBy';
  static const String sortOrder = 'sortOrder';
  static const String limit = 'limit';
}

/// Shared task pagination defaults.
abstract final class TaskDefaults {
  TaskDefaults._();

  static const int pageSize = 10;
}

/// Centralized hero tags for tasks FABs.
abstract final class HeroTags {
  HeroTags._();

  static const String tasksProfileFab = 'tasks_fab_profile';
  static const String tasksNewTaskFab = 'tasks_fab_new_task';
}

/// Storage keys used by auth/session handling.
abstract final class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
}

/// Common HTTP headers/values.
abstract final class HttpHeadersConst {
  HttpHeadersConst._();

  static const String authorization = 'Authorization';
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String bearerPrefix = 'Bearer ';
}

/// Request extra keys used by Dio interceptors.
abstract final class RequestExtraKeys {
  RequestExtraKeys._();

  static const String skipAuthInterceptor = 'skipAuthInterceptor';
  static const String retried = 'retried';
}

/// HTTP methods used by offline request queue.
abstract final class HttpMethods {
  HttpMethods._();

  static const String post = 'POST';
  static const String get = 'GET';
  static const String patch = 'PATCH';
  static const String delete = 'DELETE';
}
