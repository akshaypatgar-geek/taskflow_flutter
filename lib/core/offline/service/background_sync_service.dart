import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:taskflowapp/core/config/app_config.dart';
import 'package:taskflowapp/core/injection/injection.dart';
import 'package:taskflowapp/core/offline/offline_request_hive.dart';
import 'package:taskflowapp/core/offline/service/offline_service.dart';
import 'package:taskflowapp/features/categories/local/model/category_hive/category_hive.dart';
import 'package:taskflowapp/features/profile/data/datasources/local/model/user_details_hive.dart';
import 'package:taskflowapp/features/tasks/local/model/task_hive/task_hive.dart';
import 'package:taskflowapp/hive_registrar.g.dart';
import 'package:workmanager/workmanager.dart';

import '../../theme/app_tokens.dart';

const String syncTaskName = 'com.taskflowapp.syncTask';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    log('Background task started: $taskName');
    
    if (taskName != syncTaskName) {
      return Future.value(true);
    }

    try {
      WidgetsFlutterBinding.ensureInitialized();
      
      // 1. Initialize Hive
      await Hive.initFlutter();
      Hive.registerAdapters();

      // 2. Open necessary boxes (required for injector)
      if (!Hive.isBoxOpen('userBox')) {
        await Hive.openBox<UserDetailsHive>('userBox');
      }
      if (!Hive.isBoxOpen('categories')) {
        await Hive.openBox<CategoryHive>('categories');
      }
      if (!Hive.isBoxOpen('tasks')) {
        await Hive.openBox<TaskHive>('tasks');
      }
      if (!Hive.isBoxOpen('offlineRequests')) {
        await Hive.openBox<OfflineRequestHive>('offlineRequests');
      }

      // 3. Initialize Config and DI
      await AppConfig.init();
      await initInjector();

      // 4. Check for internet connection explicitly
      final isConnected = await InternetConnection().hasInternetAccess;
      if (!isConnected) {
        log('Background sync skipped: No internet connection');
        return Future.value(false); // Task will be retried later by Workmanager
      }

      // 5. Execute sync
      final syncService = sl<OfflineSyncService>();
      final result = await syncService.retryPendingRequests();
      
      log('Background sync completed. Errors: ${result.errorMessages.length}');
      return Future.value(true);
    } catch (e, stackTrace) {
      log('Background sync failed', error: e, stackTrace: stackTrace);
      return Future.value(false);
    }
  });
}

class BackgroundSyncService {
  static bool get _isSupported {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  static Future<void> initialize() async {
    if (!_isSupported) return;
    
    await Workmanager().initialize(
      callbackDispatcher, 
    );
  }

  static Future<void> schedulePeriodicSync() async {
    if (!_isSupported) return;

    await Workmanager().registerPeriodicTask(
      'periodic-sync-task',
      syncTaskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(seconds: AppTokens.retryS),
    );
  }

  static Future<void> runOnce() async {
    if (!_isSupported) return;

    await Workmanager().registerOneOffTask(
      'oneoff-sync-task-${DateTime.now().millisecondsSinceEpoch}',
      syncTaskName,
      constraints: Constraints(

        networkType: NetworkType.connected,
      ),
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(seconds: AppTokens.retryS),

    );
  }
}
