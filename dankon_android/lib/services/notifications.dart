import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future initialize() async {
    const AndroidInitializationSettings androidInitialization =
    AndroidInitializationSettings('notification_icon');

    const InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitialization,
    );

    return _notifications.initialize(initializationSettings);
  }

  static Future _chatNotificationDetails() async {
    return const NotificationDetails(
      iOS: IOSNotificationDetails(),
      android: AndroidNotificationDetails(
        'chats',
        ':Dankon Chats',
        importance: Importance.max,
      )
    );
  }

  static Future handleChatNotification(Map<String, dynamic> data) async {
    _notifications.show(data["id"].hashCode, data["senderName"], "New messages", await _chatNotificationDetails());
  }
}