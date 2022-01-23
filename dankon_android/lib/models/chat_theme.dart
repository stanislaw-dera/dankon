import 'package:flutter/material.dart';

class ChatTheme {
  String id;
  String name;
  Color backgroundColor;
  Color secondaryColor;
  Color textColor;
  Color messageTextColor;
  Color messageBackgroundColor;
  Color myMessageTextColor;
  Color myMessageBackgroundColor;
  Color buttonsColor;

  ChatTheme(
      {required this.id,
      required this.name,
      required this.backgroundColor,
      required this.secondaryColor,
      required this.textColor,
      required this.messageTextColor,
      required this.messageBackgroundColor,
      required this.myMessageTextColor,
      required this.myMessageBackgroundColor,
      required this.buttonsColor});
}
