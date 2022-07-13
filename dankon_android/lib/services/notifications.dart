import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dankon/constants/constants.dart';

class NotificationsService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static AndroidNotificationChannel chatsChannel = const AndroidNotificationChannel(
    'chats_channel',
    ':Dankon Chats',
    importance: Importance.max,
  );


  static Future initialize() async {
    const AndroidInitializationSettings androidInitialization =
    AndroidInitializationSettings('notification_icon');

    const InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitialization,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(chatsChannel);

    return _notifications.initialize(initializationSettings);
  }

  static Future _chatNotificationDetails() async {
    return NotificationDetails(
      iOS: const IOSNotificationDetails(),
      android: AndroidNotificationDetails(
        chatsChannel.id,
        chatsChannel.name,
        importance: chatsChannel.importance,
        icon: "chat_notification_icon",
        color: kPinkColor,
      )
    );
  }

  static Future handleChatNotification(Map<String, dynamic> data) async {
    _notifications.show(data["id"].hashCode, data["senderName"], "New messages", await _chatNotificationDetails());
  }
}