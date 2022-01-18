import 'package:dankon/models/chat_theme.dart';
import 'package:dankon/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageBuble extends StatelessWidget {
  const MessageBuble({Key? key, required this.msg, required this.byMe}) : super(key: key);
  final Message msg;
  final bool byMe;

  @override
  Widget build(BuildContext context) {

    ChatTheme chatTheme = context.watch<ChatTheme>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10),
      child: Row(
        mainAxisAlignment: byMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: byMe ? chatTheme.myMessageBackgroundColor : chatTheme.messageBackgroundColor,
              borderRadius: BorderRadius.circular(30),
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
        )],
      ),
    );
  }
}
