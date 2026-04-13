import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/config/app_config.dart';
import 'package:taskflowapp/core/notifications/data/notification_repository.dart';
import 'package:taskflowapp/core/notifications/web_notification_handler.dart';
import 'package:taskflowapp/core/routes/router.dart';
import 'package:taskflowapp/core/session_manager/session_manager.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message ${message.messageId}');
}

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final NotificationRepository _repository;
  final SessionManager _sessionManager;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  GoRouter? _router;
  bool _isTokenSetup = false;
  String? _pendingTaskId;

  NotificationService(this._repository, this._sessionManager);

  String? get pendingTaskId => _pendingTaskId;

  void consumePendingTask() {
    _pendingTaskId = null;
  }

  Future<void> initialize(GoRouter router) async {
    _router = router;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        if (details.payload != null) {
          _handlePayload(details.payload!);
        }
      },
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    if (!kIsWeb) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    // Request permissions
    final NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted notification permission');
      await setupToken();
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      if (message.notification != null) {
        _showLocalNotification(message, channel);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    final RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }
  }

  Future<void> _showLocalNotification(
      RemoteMessage message, AndroidNotificationChannel channel) async {
    final notification = message.notification;
    if (notification == null) return;

    if (kIsWeb) {
      showWebNotification(message);
      return;
    }

    final String? taskId = message.data['taskId']?.toString();

    final android = message.notification?.android;
    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: android?.smallIcon ?? '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: taskId,
    );
  }

  Future<void> setupToken({int retryCount = 0}) async {
    final hasSession = await _sessionManager.hasValidSession();
    if (!hasSession) {
      if (retryCount < 3) {
        debugPrint('No valid session yet, retrying setupToken in 1s (Attempt ${retryCount + 1})...');
        await Future.delayed(const Duration(seconds: 1));
        return setupToken(retryCount: retryCount + 1);
      }
      debugPrint('Skipping FCM token setup: No valid session after retries.');
      return;
    }

    final String? token = await _fcm.getToken(
      vapidKey: kIsWeb ? AppConfig.vapidKey : null,
    );
    
    if (token != null) {
      debugPrint('FCM Token: $token');
      try {
        await _repository.subscribeToTopic(token);
        _isTokenSetup = true;
      } catch (e) {
        debugPrint('Failed to subscribe: $e');
      }
    }

    _fcm.onTokenRefresh.listen((newToken) async {
      final stillHasSession = await _sessionManager.hasValidSession();
      if (stillHasSession) {
        await _repository.subscribeToTopic(newToken);
      }
    });
  }

  void _handleMessageTap(RemoteMessage message) {
    _handlePayload(message.data['taskId']?.toString());
  }

  Future<void> _handlePayload(String? taskId) async {
    if (taskId == null || _router == null) return;

    final hasSession = await _sessionManager.hasValidSession();
    if (hasSession) {
      _router!.pushNamed(
        ScreenPaths.taskDetail.name,
        pathParameters: {'id': taskId},
      );
    } else {
      _pendingTaskId = taskId;
      _router!.goNamed(ScreenPaths.login.name);
    }
  }
}
