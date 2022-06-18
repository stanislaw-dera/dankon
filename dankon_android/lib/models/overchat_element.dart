import 'package:dankon/models/chat.dart';
import 'package:flutter/material.dart';

class OverchatElement {
  final String name;
  final String description;
  final Color foregroundColor;
  final Color backgroundColor;
  final Widget inChatWidget;
  final void Function(BuildContext context, Chat chat) send;

  OverchatElement(
      {required this.name,
      this.description = "",
      this.foregroundColor = Colors.black,
      this.backgroundColor = Colors.white,
      required this.inChatWidget,
      required this.send});
}
