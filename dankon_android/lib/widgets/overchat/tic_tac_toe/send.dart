import 'package:dankon/models/chat.dart';
import 'package:dankon/widgets/overchat/tic_tac_toe/start_bottom_sheet.dart';
import 'package:flutter/material.dart';

void send(BuildContext context, Chat chat) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return StartTicTacToeBottomSheet(chat: chat);
      });
}