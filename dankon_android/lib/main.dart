import 'package:dankon/constants/constants.dart';
import 'package:dankon/firebase_options.dart';
import 'package:dankon/screens/chat/chat_view.dart';
import 'package:dankon/screens/main/search.dart';
import 'package:dankon/screens/settings/settings.dart';
import 'package:dankon/services/authentication.dart';
import 'package:dankon/services/notifications.dart';
import 'package:dankon/widgets/chat_entry.dart';
import 'package:dankon/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> _notificationHandler(RemoteMessage message) async {
  if(message.data["type"] == "CHAT/NEW_MESSAGE") NotificationsService.handleChatNotification(message.data);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  NotificationsService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_notificationHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dankon',
        theme: kThemeData,
        initialRoute: '/',
        routes: {
          '/': (context) => const Wrapper(),
          '/search': (context) => const SearchScreen(),
          '/chat': (context) => const ChatView(),
          '/settings': (context) => const SettingsScreen(),
          '/chat-entry': (context) => const ChatEntry(),
        },
      ),
    );
  }
}
