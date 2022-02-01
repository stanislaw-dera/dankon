import 'package:dankon/models/chat.dart';
import 'package:dankon/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatEntry extends StatefulWidget {
  const ChatEntry({Key? key}) : super(key: key);

  @override
  _ChatEntryState createState() => _ChatEntryState();
}

class _ChatEntryState extends State<ChatEntry> {
  void setup() async {
    String chatId = ModalRoute.of(context)!.settings.arguments as String;
    String myUid = context.read<User?>()!.uid;
    Chat chat = await DatabaseService(uid: myUid).getChatById(chatId);
    Navigator.pushReplacementNamed(context, "/chat", arguments: chat);
  }

  @override
  Widget build(BuildContext context) {
    setup();
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
