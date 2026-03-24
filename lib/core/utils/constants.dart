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
  static const String submit = 'Submit';

  // --- Validation errors ---
  static const String emailRequired = 'Email required';
  static const String invalidEmailFormat = 'Invalid email format';
  static const String passwordRequired = 'Password cannot be empty';
  static const String passwordTooShort = 'Password too short';
  static const String titleRequired = 'Title required';
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
  static const String noCategoriesYet = 'No categories yet. Tap + to create one.';
  static const String genericError = 'Error';
  static const String failedToLoad = 'Failed to load';
  static const String pageNotFound = 'Page Not Found';
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
  static const String termsAndConditions = 'Terms & Conditions';
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
}
