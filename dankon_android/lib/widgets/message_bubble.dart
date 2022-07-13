import 'package:dankon/models/chat.dart';
import 'package:dankon/models/chat_theme.dart';
import 'package:dankon/models/message.dart';
import 'package:dankon/widgets/message_details_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageBuble extends StatelessWidget {
  const MessageBuble({Key? key, required this.msg, required this.byMe, this.isThereMessageAfter = false, this.isThereMessageBefore = false}) : super(key: key);
  final Message msg;
  final bool byMe;
  final bool isThereMessageAfter;
  final bool isThereMessageBefore;

  @override
  Widget build(BuildContext context) {

    ChatTheme chatTheme = context.watch<ChatTheme>();
    Chat chat = context.read<Chat>();
    Radius defaultRadius =  const Radius.circular(20);

    return Row(
      mainAxisAlignment: byMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [Flexible(
        child: GestureDetector(
          onLongPress: () => byMe ? showModalBottomSheet(context: context, builder: (BuildContext context) => MessageDetailsSheet(msg: msg, chat: chat,)) : () => {},
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: byMe ? chatTheme.myMessageBackgroundColor : chatTheme.messageBackgroundColor,
              borderRadius: BorderRadius.only(
                topRight: byMe && isThereMessageBefore ? Radius.zero : defaultRadius,
                bottomRight: byMe && isThereMessageAfter ? Radius.zero : defaultRadius,
                topLeft: !byMe && isThereMessageBefore ? Radius.zero : defaultRadius,
                bottomLeft: !byMe && isThereMessageAfter ? Radius.zero : defaultRadius,
              ),
            ),
            child: Linkify(
              text: msg.content,
              style: TextStyle(
                  color: byMe ? chatTheme.myMessageTextColor : chatTheme.messageTextColor,
                  fontSize: 16
              ),
              linkStyle: TextStyle(
                  color: byMe ? chatTheme.myMessageTextColor : chatTheme.messageTextColor,
                  fontSize: 16,
                  decoration: TextDecoration.underline
              ),
              onOpen: (link) async {
                if (await canLaunch(link.url)) {
                  await launch(link.url);
                } else {
                  throw 'Could not launch $link';
                }
              },
            )
          ),
        ),
      )],
    );
  }
}
