import 'dart:developer';

import 'package:taskflowapp/core/offline/repository/offline_request_repository.dart';

class OfflineSyncService {
  final OfflineRequestRepository offlineRepo;

  OfflineSyncService(this.offlineRepo);

  bool _isSyncing = false;

  Future<void> retryPendingRequests() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final pending = offlineRepo.getPendingRequests();

      for (final request in pending) {
        try {
          await offlineRepo.executeRequest(request);
        } catch (e, stackTrace) {
          log(
            'Offline sync failed for ${request.method} ${request.endPoint}',
            error: e,
            stackTrace: stackTrace,
          );
        }
      }
    } finally {
      _isSyncing = false;
    }
  }
}