import 'package:dankon/screens/auth/sign_in.dart';
import 'package:dankon/screens/main/main_view.dart';
import 'package:dankon/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'firebase_options.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'CHAT/NEW_MESSAGE' && message.data.containsKey("id")) {
      Navigator.pushNamed(context, '/chat-entry', arguments: message.data["id"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    if (firebaseUser == null) {
      return const SignIn();
    } else {
      messaging.getToken().then((value) {
        DatabaseService(uid: firebaseUser.uid)
            .saveNotificationsToken(value.toString());
      });

      return const MainView();
    }
  }
}
