
import 'package:taskflowapp/core/offline/repository/offline_request_repository.dart';

class OfflineSyncService {
  final OfflineRequestRepository offlineRepo; // wrapper around Hive

  OfflineSyncService(this.offlineRepo);

  bool _isSyncing = false;

  Future<void> retryPendingRequests() async {
    if (_isSyncing) return; // prevent duplicates
    _isSyncing = true;

    try {
      final pending = offlineRepo.getPendingRequests(); // read from Hive
      
      for (final request in pending) {
        try {
          await offlineRepo.executeRequest(request); // send to API
          await offlineRepo.deleteRequest(request: request); // delete after success
        } catch (e) {
          // Optionally log but continue with others
        }
      }
    } finally {
      _isSyncing = false;
    }
  }
}