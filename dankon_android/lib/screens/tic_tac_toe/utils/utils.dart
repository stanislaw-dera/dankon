import 'package:dankon/screens/tic_tac_toe/models/player.dart';
import 'package:flutter/material.dart';

class TicTacToeUtils {

  static List<Widget> modelBuilder<M>(
      List<M> models, Widget Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, Widget>(
              (index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();

  static bool isEnd(List<List<String>> board) =>
      board.every((values) => values.every((value) => value != Player.none));

  static Color getFieldColor(String value) {
    switch (value) {
      case Player.O:
        return Colors.blue;
      case Player.X:
        return Colors.red;
      default:
        return Colors.white;
    }
  }
}