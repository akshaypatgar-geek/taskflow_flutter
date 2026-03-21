# TaskFlow — Flutter App Documentation

## Overview

TaskFlow is a Flutter mobile application for task management. It features JWT authentication, real-time updates via WebSocket, offline-first architecture with Hive local storage and an offline request queue, cursor-based pagination, category filtering, and light/dark theme support.

---

## Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter / Dart | UI framework |
| flutter_bloc | State management (BLoC pattern) |
| Dio | HTTP client |
| GoRouter | Declarative routing with deferred loading |
| Hive CE | Local database (offline cache) |
| FlutterSecureStorage | Secure token storage |
| Socket.IO Client | Real-time WebSocket events |
| Freezed | Immutable data models with JSON serialization |
| dartz | Functional `Either` type for error handling |
| internet_connection_checker_plus | Connectivity monitoring |

---

## Project Structure

```
lib/
├── main.dart                                # App entry point
├── hive_registrar.g.dart                    # Generated Hive adapter registration
│
├── core/
│   ├── auth_interceptor.dart                # Dio interceptor for JWT + auto-refresh
│   ├── network/
│   │   ├── dio_client.dart                  # HTTP client (generic typed methods)
│   │   ├── end_points.dart                  # API endpoint constants
│   │   ├── exceptions.dart                  # AppException hierarchy
│   │   ├── failures.dart                    # Failure hierarchy (exposed to UI)
│   │   ├── exception_to_failure.dart        # Exception → Failure mapper
│   │   ├── exception_response/              # API error response model (Freezed)
│   │   ├── network_service.dart             # Connectivity stream
│   │   ├── network_repository.dart          # Connectivity repository
│   │   └── bloc/                            # NetworkBloc (online/offline state)
│   ├── offline/
│   │   ├── offline_request.dart             # Request model
│   │   ├── offline_request_hive.dart        # Hive model for queued requests
│   │   ├── repository/offline_request_repository.dart  # Queue CRUD + execute
│   │   └── service/offline_service.dart     # Sync service (replay pending)
│   ├── routes/
│   │   ├── routers.dart                     # GoRouter config with deferred imports
│   │   ├── route_builders.dart              # Screen builders with DI
│   │   ├── route_extras.dart                # Typed route extras (sealed classes)
│   │   ├── deferred_route_loader.dart       # Lazy-load widget for deferred screens
│   │   └── go_router_refresh_stream.dart    # Auth stream → GoRouter refresh
│   ├── theme/
│   │   └── app_theme.dart                   # Light/dark themes + AppStatusColors
│   ├── utils/
│   │   ├── enums.dart                       # TaskStatusEnum, SyncStatus
│   │   ├── error_screen.dart                # 404 / route error screen
│   │   └── snackbar_helper.dart             # Success/error snackbar helpers
│   └── websocket/
│       └── socket_service.dart              # Socket.IO singleton with reconnect
│
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   │   ├── entities/                         # AuthTokens, AuthUser
│   │   │   ├── repository/auth_repository_interface.dart
│   │   │   └── usecases/                         # CheckSession, Login, SignUp, Logout
│   │   ├── data/
│   │   │   ├── repository/auth_repository_impl.dart
│   │   │   └── model/                            # RefreshTokenResponse, CreateUserResponse
│   │   └── presentation/
│   │       ├── bloc/auth/                         # AuthBloc, events, states
│   │       ├── screen/                            # Landing, Login, SignUp screens
│   │       └── widget/log_in_input.dart           # Shared email/password form
│   │
│   ├── tasks/
│   │   ├── data/
│   │   │   ├── repository/
│   │   │   │   ├── task_repository.dart           # Single-task CRUD
│   │   │   │   └── tasks_repository.dart          # Task list (pagination)
│   │   │   └── model/                             # Task, ListTasksResponse, DeleteTaskResponse
│   │   ├── local/
│   │   │   ├── model/task_hive/                   # TaskHive model
│   │   │   └── repository/task_local_repository.dart  # Local CRUD + filtered queries
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── task/                          # TaskBloc (single task operations)
│   │       │   └── tasks/                         # TasksBloc (list, pagination, WebSocket)
│   │       ├── screen/
│   │       │   ├── tasks_screen.dart              # Task list with search/filter/sort
│   │       │   ├── task_form_screen.dart           # Create/edit task form
│   │       │   └── task_details_screen.dart        # Task detail view
│   │       └── widgets/task_tile.dart             # Task list item
│   │
│   ├── categories/
│   │   ├── data/
│   │   │   ├── repository/category_repository.dart
│   │   │   └── model/                             # Category, ListCategoriesResponse
│   │   ├── local/model/category_hive/             # CategoryHive model
│   │   └── services/category_service.dart         # Cached category fetching
│   │
│   ├── profile/
│   │   ├── domain/
│   │   │   ├── entities/profile_user.dart
│   │   │   ├── repository/profile_repository_interface.dart
│   │   │   └── usecases/                          # GetCachedProfile, GetProfileDetails, UpdateProfile
│   │   ├── data/
│   │   │   ├── repository/profile_repository_impl.dart
│   │   │   └── model/user_details/               # UserDetails (Freezed)
│   │   ├── local/
│   │   │   ├── model/user_details_hive.dart       # UserDetailsHive
│   │   │   └── user_profile_local_repository/     # Local profile CRUD
│   │   └── presentation/
│   │       ├── bloc/profile/                      # ProfileBloc
│   │       └── screen/profile_screen.dart
│   │
│   └── session_manager/
│       └── session_manager.dart                   # Token storage + JWT validation
```

---

## App Startup Flow (`main.dart`)

1. **`WidgetsFlutterBinding.ensureInitialized()`**
2. **Initialize Hive** — register adapters, open boxes (`userBox`, `categories`, `tasks`, `offlineRequests`).
3. **Load `.env`** — `BASE_URL`, `WEBSOCKET_URL`.
4. **`runApp(MyApp())`**:
   - `MultiRepositoryProvider` — provides `FlutterSecureStorage`, `DioClient`, `SessionManager`, `AuthRepositoryInterface` (impl: `AuthRepositoryImpl`), `CheckSessionUseCase`, `LoginUseCase`, `SignUpUseCase`, `LogoutUseCase`, `CategoryRepository`, `CategoryService`, `OfflineRequestRepository`, `NetworkService`, `NetworkRepository`, `SocketService`, `OfflineSyncService`.
   - `MultiBlocProvider` — creates `NetworkBloc` (starts monitoring), `AuthBloc` (checks session).
   - `MaterialApp.router` — with `AppTheme.light`, `AppTheme.dark`, `ThemeMode.system`, and `GoRouter`.

---

## Authentication

### Session Check (on app start)
1. Check if access token exists and is not expired → `AuthAuthenticated`.
2. If expired but token exists → attempt refresh via API.
3. If refresh fails (offline) → still emit `AuthAuthenticated` (allow offline access with cached data).
4. If no token at all → `AuthUnauthenticated` → redirect to login.

### AuthBloc States
| State | Description |
|-------|-------------|
| `AuthInitial` | App just started |
| `AuthLoggingIn` | Login/signup in progress |
| `AuthAuthenticated` | User is logged in |
| `AuthUnauthenticated` | No valid session |
| `AuthLoginFailed` | Login error with message |
| `SignUpSuccess` | Registration succeeded |
| `SignUpFailed` | Registration error |

### Token Management
- **SessionManager** — reads/writes `access_token` in `FlutterSecureStorage`, checks expiry via `jwt_decoder`.
- **AuthInterceptor** — attaches Bearer token to every request, auto-refreshes on 401 (one retry), stores new tokens.
- **Logout** — clears tokens, Hive task box, and user box.

---

## Network Layer

### DioClient
- Base URL from `.env`.
- Generic typed methods: `getRequest<T>()`, `postRequest<T>()`, `patchRequest<T>()`, `deleteRequest<T>()` → `Future<T?>`.
- Error handling maps `DioException` to app exceptions:
  - Connection/timeout → `NetworkException`
  - 404 → `NotFoundException`
  - 409 → `ExistsException`
  - 401 → `UnauthorizedException`
  - Other → `ServerException`

### Exception → Failure Mapping
Repositories catch `AppException` and convert via `exceptionToFailure()`:

| Exception | Failure |
|-----------|---------|
| `NetworkException` | `NetworkFailure` |
| `NotFoundException` | `NotFoundFailure` |
| `ExistsException` | `ExistsFailure` |
| `UnauthorizedException` | `UnauthorizedFailure` |
| `ServerException` | `ServerFailure` |

Repositories return `Either<Failure, T>` so the presentation layer handles both cases via `.fold()`.

---

## Offline Support

### Architecture
The app is offline-first: it shows cached data immediately, then fetches from the API in the background.

### Hive Boxes
| Box Name | Model | Purpose |
|----------|-------|---------|
| `tasks` | `TaskHive` | Cached tasks |
| `categories` | `CategoryHive` | Cached categories |
| `userBox` | `UserDetailsHive` | Cached user profile |
| `offlineRequests` | `OfflineRequestHive` | Queued mutations (create/update/delete) |

### Offline Request Queue
When a task mutation fails with `NetworkFailure`:
1. The request (method, endpoint, body) is saved to the `offlineRequests` Hive box.
2. The task is saved locally with `SyncStatus.PENDING`.
3. The UI shows the task immediately (optimistic update).

### Sync on Reconnect
- `NetworkBloc` monitors connectivity via `internet_connection_checker_plus`.
- When `NetworkOnline` is emitted, `OfflineSyncService.retryPendingRequests()` replays all queued requests.
- Each successful request is removed from the queue.
- A `_isSyncing` flag prevents concurrent sync runs.

### Local Task Repository
- `getFilteredTasks()` filters on `TaskHive` fields (status, categoryId, searchKey) as a lazy `Iterable` before converting to `Task` — avoids loading all tasks into memory.
- `getTaskById()` does a direct key lookup on the Hive box.

---

## Real-Time Updates (WebSocket)

### SocketService (Singleton)
- Connects via Socket.IO to `WEBSOCKET_URL` with `{ auth: { token } }`.
- Listens for: `task.created`, `task.updated`, `task.deleted`.
- Exposes a broadcast `Stream<Map<String, dynamic>>` via `taskUpdates`.
- Reconnection: up to 2 retries with 3-second delay.

### Integration with BLoCs
- **TasksBloc** subscribes in constructor → dispatches `AddTaskToList`, `UpdateOneTask`, `RemoveTaskFromList`.
- **TaskBloc** subscribes → dispatches `UpdateToExistingTask` or emits `TaskDeletionSuccess`.
- Connection is established from `TasksScreen` when `NetworkOnline` is received.

---

## State Management (BLoC)

### TasksBloc (Task List)
| Event | Description |
|-------|-------------|
| `ListUserTasks` | Load tasks (cache-first, then API) |
| `LoadMoreTasks` | Cursor-based pagination |
| `AddTaskToList` | Add from WebSocket or creation |
| `UpdateOneTask` | Update in list from WebSocket |
| `RemoveTaskFromList` | Remove from list |

**Flow**: Emit `TasksLoading` → show cached tasks → fetch from API → save to Hive → emit `TasksListingSuccess`.

### TaskBloc (Single Task)
| Event | Description |
|-------|-------------|
| `GetTaskDetails` | Fetch task (cache + API) |
| `CreateTaskEvent` | Create (offline-aware) |
| `UpdateTaskEvent` | Update (offline-aware) |
| `DeleteTask` | Delete (offline-aware) |
| `UpdateToExistingTask` | WebSocket update |

**Offline-aware**: On `NetworkFailure`, saves locally with `SyncStatus.PENDING` and emits success.

### ProfileBloc
| Event | Description |
|-------|-------------|
| `GetProfileDetailsEvent` | Load profile (cache + API) |
| `UpdateProfileEvent` | Update name/picture |

### NetworkBloc
| Event | Description |
|-------|-------------|
| `StartNetworkMonitoring` | Subscribe to connectivity changes |
| `NetworkStatusChanged` | Emit `NetworkOnline` / `NetworkOffline` |

---

## Routing (GoRouter)

### Routes
| Path | Name | Screen |
|------|------|--------|
| `/` | landing | Loading → redirect based on auth |
| `/login` | logIn | Login screen |
| `/signup` | signUp | Sign up screen |
| `/tasks` | tasks | Task list (with DI) |
| `/task_form` | taskForm | Create/edit task form |
| `/task/:id` | taskDetail | Task detail view |
| `/profile` | profile | User profile |

### Auth Redirect
- `refreshListenable: GoRouterRefreshStream(authBloc.stream)` — re-evaluates redirect on auth changes.
- `AuthUnauthenticated` + not on login/signup → redirect to `/login`.
- `AuthAuthenticated` + on login/signup → redirect to `/tasks`.

### Deferred Loading
All screens use `deferred as` imports and `DeferredRouteLoader` — screen code is loaded on-demand, reducing initial bundle size.

### Typed Route Extras (Sealed Classes)
```
TaskFormExtra (sealed)
├── CreateTaskFormExtra(TasksBloc tasksBloc)
└── EditTaskFormExtra(Task task, TaskBloc taskBloc)

TaskDetailExtra(TasksBloc tasksBloc)
```

Route builders use `is!` type checks (no unsafe casts) to extract extras.

### Route Builders
- `TasksRouteBuilder` — provides `TasksRepository`, `LocalTasksRepository`, `TasksBloc`.
- `TaskFormRouteBuilder` — provides `TaskRepository`, `TaskBloc` for create; uses existing `TaskBloc` for edit.
- `TaskDetailRouteBuilder` — provides `TaskRepository`, `TaskBloc` with `GetTaskDetails`.

---

## Theming

### Light Theme
- Surface: `#F5F5F5`, Card: `#FFFFFF`, Primary: `#212121`.
- Material 3 color scheme.

### Dark Theme
- Surface: `#121212`, Card: `#1E1E1E`, Primary: `#E1E1E1`.
- Material 3 color scheme.

### AppStatusColors (ThemeExtension)
| Property | Light | Dark |
|----------|-------|------|
| `open` | Blue | Light blue |
| `inProgress` | Orange | Light orange |
| `done` | Green | Light green |
| `highPriority` | Red | Light red |
| `mediumPriority` | Orange | Light orange |
| `lowPriority` | Green | Light green |

Theme mode: `ThemeMode.system` (follows device setting).

---

## Data Models (Freezed)

### Task
| Field | Type | JSON Key |
|-------|------|----------|
| `taskId` | String | `id` |
| `title` | String | `title` |
| `createdAt` | DateTime | `createdAt` |
| `updatedAt` | DateTime | `updatedAt` |
| `authorId` | String | `authorId` |
| `priority` | String? | `priority` |
| `categoryId` | String? | `categoryId` |
| `status` | TaskStatusEnum | `status` |
| `syncStatus` | SyncStatus | — (default SYNCED) |

### Category
| Field | Type | JSON Key |
|-------|------|----------|
| `categoryId` | String | `id` |
| `categoryName` | String | `title` |

### UserDetails
| Field | Type | JSON Key |
|-------|------|----------|
| `userId` | String | `id` |
| `userName` | String? | `name` |
| `userEmail` | String | `email` |
| `userStatus` | String | `status` |
| `profilePicture` | String? | `profilePicture` |

---

## Local Storage (Hive)

| Model | TypeId | Fields |
|-------|--------|--------|
| `TaskHive` | 2 | taskId, title, createdAt, updatedAt, authorId, categoryId, priority, status, syncStatus |
| `CategoryHive` | 3 | categoryId, categoryName |
| `UserDetailsHive` | 1 | userId, userName, userEmail, userStatus, profilePicture |
| `OfflineRequestHive` | 4 | method, endPoint, body, queryParameters, createdAt |

Adapters are registered via generated `hive_registrar.g.dart`.

---

## Category Service Caching

`CategoryService` uses two cache layers to avoid redundant API calls:
1. **Result cache** (`Map<String, Category>`) — returns instantly for known categories.
2. **In-flight future cache** (`Map<String, Future<Category?>>`) — deduplicates concurrent requests for the same category (e.g. from `FutureBuilder` rebuilds).

`listCategories()` is wrapped in try/catch — returns Hive-cached data when offline.

---

## Key Packages

| Package | Purpose |
|---------|---------|
| `flutter_bloc` / `bloc` | BLoC state management |
| `dio` | HTTP client |
| `go_router` | Declarative routing |
| `freezed_annotation` / `freezed` | Immutable models + code generation |
| `json_annotation` / `json_serializable` | JSON serialization |
| `dartz` | `Either<Failure, T>` for error handling |
| `hive_ce` / `hive_ce_flutter` | Local database |
| `flutter_secure_storage` | Encrypted token storage |
| `socket_io_client` | WebSocket client |
| `jwt_decoder` | JWT expiry checking |
| `internet_connection_checker_plus` | Connectivity monitoring |
| `uuid` | Client-side ID generation for offline task creation |
| `email_validator` | Email format validation |
| `flutter_dotenv` | Environment variables |
| `equatable` | Value equality for BLoC states/events |
| `intl` | Date formatting |

---

## Running the Project

```bash
# Install dependencies
flutter pub get

# Generate code (Freezed models, Hive adapters)
dart run build_runner build --delete-conflicting-outputs

# Create .env file with
BASE_URL=http://your-api-url
WEBSOCKET_URL=http://your-websocket-url

# Run the app
flutter run
```
