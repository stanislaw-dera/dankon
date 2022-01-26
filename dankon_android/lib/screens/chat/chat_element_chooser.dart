import 'package:dankon/models/message.dart';
import 'package:dankon/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatElementChooser extends StatelessWidget {
  const ChatElementChooser({Key? key, required this.message, this.previousMessage, this.nextMessage}) : super(key: key);

  final Message message;
  final Message? previousMessage;
  final Message? nextMessage;

  @override
  Widget build(BuildContext context) {

    String myUid = context.read<User?>()!.uid;

    bool threadTheMessageAbove = previousMessage != null && previousMessage!.author == message.author && message.time.difference(previousMessage!.time).inMinutes < 3;
    bool threadTheMessageBelow = nextMessage != null && nextMessage!.author == message.author && message.time.difference(nextMessage!.time).inMinutes < 3;

    if(message.type == "TEXT_MESSAGE") {
      return Padding(
        padding: EdgeInsets.only(top: threadTheMessageAbove ? 2 : 30),
        child: MessageBuble(msg: message, byMe: message.author == myUid, isThereMessageBefore: threadTheMessageAbove, isThereMessageAfter: threadTheMessageBelow,),
      );
    }

    return Container();
  }
}

