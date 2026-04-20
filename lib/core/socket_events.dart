sealed class TaskSocketEvent {
  const TaskSocketEvent();
}

class TaskSocketCreated extends TaskSocketEvent {
  const TaskSocketCreated(this.payload);

  final Map<String, dynamic> payload;
}

class TaskSocketUpdated extends TaskSocketEvent {
  const TaskSocketUpdated(this.payload);

  final Map<String, dynamic> payload;
}

class TaskSocketDeleted extends TaskSocketEvent {
  const TaskSocketDeleted(this.payload);

  final Map<String, dynamic> payload;
}
