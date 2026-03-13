
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
          await offlineRepo.deleteRequest(request: request); 
        } catch (e) {
          
        }
      }
    } finally {
      _isSyncing = false;
    }
  }
}