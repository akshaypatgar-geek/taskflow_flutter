import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> showWebNotification(RemoteMessage message) async {
  // Use standard web package checks
  if (web.Notification.permission == 'granted') {
    _display(message);
  } else if (web.Notification.permission != 'denied') {
    final permission = await web.Notification.requestPermission().toDart;
    if ((permission).toDart == 'granted') {
      _display(message);
    }
  }
}

void _display(RemoteMessage message) {
  final notification = message.notification;
  if (notification == null) return;

  final taskId = message.data['taskId']?.toString();
  
  final options = web.NotificationOptions(
    body: notification.body ?? '',
    icon: '/icons/Icon-192.png',
  );

  final webNotification = web.Notification(
    notification.title ?? 'New Message',
    options,
  );

  webNotification.onclick = (web.Event event) {
    if (taskId != null) {
      // Navigating via hash ensures GoRouter processes the deep link
      web.window.location.hash = '#/tasks/$taskId';
    }
    webNotification.close();
    web.window.focus();
  }.toJS;
}
