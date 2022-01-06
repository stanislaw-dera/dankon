import 'package:dankon/constants.dart';
import 'package:dankon/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MessageBuble extends StatelessWidget {
  const MessageBuble({Key? key, required this.msg, required this.byMe}) : super(key: key);
  final Message msg;
  final bool byMe;

  @override
  Widget build(BuildContext context) {
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
              color: byMe ? kPrimaryColor : kPrimaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              msg.content,
              style: const TextStyle(
                color: kDarkColor,
                fontSize: 15
              ),
            ),
          ),
        )],
      ),
    );
  }
}
