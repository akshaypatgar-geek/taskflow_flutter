

part of 'task_bloc.dart';


@immutable
sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

final class TaskInitial extends TaskState {}

class TaskUpdateSuccess extends TaskState {
  final TaskEntity task;

  TaskUpdateSuccess({required this.task});

  @override
  List<Object?> get props => [task];
}

class TaskCreationSuccess extends TaskState {
  final TaskEntity task;

  TaskCreationSuccess({required this.task});

  @override
  List<Object?> get props => [task];
}

class TaskDeletionSuccess extends TaskState {
  final String taskId;

  TaskDeletionSuccess({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class TaskDetailsSuccess extends TaskState {
  final TaskEntity task;
  final bool isSaving;
  final String? saveFailureMessage;

  final String draftTitle;
  final String draftPriority;
  final TaskStatusEnum draftStatus;
  final bool isEditingTitle;
  final String? titleFieldError;

  TaskDetailsSuccess({
    required this.task,
    this.isSaving = false,
    this.saveFailureMessage,
    required this.draftTitle,
    required this.draftPriority,
    required this.draftStatus,
    this.isEditingTitle = false,
    this.titleFieldError,
  });

  factory TaskDetailsSuccess.fromTask(TaskEntity task) {
    return TaskDetailsSuccess(
      task: task,
      draftTitle: task.title,
      draftPriority: (task.priority ?? 'LOW').toUpperCase(),
      draftStatus: task.status ?? TaskStatusEnum.OPEN,
    );
  }

  bool get hasUnsavedDraftChanges {
    final trimmed = draftTitle.trim();
    final serverP = (task.priority ?? 'LOW').toUpperCase();
    final serverS = task.status ?? TaskStatusEnum.OPEN;
    return trimmed != task.title ||
        draftPriority != serverP ||
        draftStatus != serverS;
  }

  bool get showInlineUpdateButton => hasUnsavedDraftChanges || isEditingTitle;

  TaskDetailsSuccess copyWith({
    TaskEntity? task,
    bool? isSaving,
    String? saveFailureMessage,
    bool clearSaveFailureMessage = false,
    String? draftTitle,
    String? draftPriority,
    TaskStatusEnum? draftStatus,
    bool? isEditingTitle,
    String? titleFieldError,
    bool clearTitleFieldError = false,
  }) {
    return TaskDetailsSuccess(
      task: task ?? this.task,
      isSaving: isSaving ?? this.isSaving,
      saveFailureMessage: clearSaveFailureMessage
          ? null
          : (saveFailureMessage ?? this.saveFailureMessage),
      draftTitle: draftTitle ?? this.draftTitle,
      draftPriority: draftPriority ?? this.draftPriority,
      draftStatus: draftStatus ?? this.draftStatus,
      isEditingTitle: isEditingTitle ?? this.isEditingTitle,
      titleFieldError:
          clearTitleFieldError ? null : (titleFieldError ?? this.titleFieldError),
    );
  }

  @override
  List<Object?> get props => [
        task,
        isSaving,
        saveFailureMessage,
        draftTitle,
        draftPriority,
        draftStatus,
        isEditingTitle,
        titleFieldError,
      ];
}

class TaskLoading extends TaskState {}

class TaskFailedState extends TaskState {
  final String errorMessage;

  TaskFailedState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
