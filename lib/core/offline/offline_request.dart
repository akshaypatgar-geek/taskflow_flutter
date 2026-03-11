class OfflineRequest {
  final String method;
  final String endpoint;
  Map<String, dynamic>? body;
  Map<String, dynamic>? queryParams;

  OfflineRequest({required this.method, required this.endpoint, this.body,  this.queryParams});
  
}