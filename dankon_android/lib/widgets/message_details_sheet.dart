import 'package:dankon/models/chat.dart';
import 'package:dankon/models/message.dart';
import 'package:dankon/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageDetailsSheet extends StatelessWidget {
  final Message msg;
  final Chat chat;

  const MessageDetailsSheet({Key? key, required this.msg, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String myUid = context.read<User?>()!.uid;

    return ListTile(
      title: const Text("Delete for everyone"),
      leading: const Icon(Icons.delete),
      onTap: () {
        DatabaseService(uid: myUid).deleteMessage(msg, chat.id);
        Navigator.of(context).pop();
      },
    );
  }
}
