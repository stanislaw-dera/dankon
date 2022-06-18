import 'package:firebase_database/firebase_database.dart';

class TicTacToeSettings {

  TicTacToeSettings({
    required this.name,
    required this.boardSize,
    required this.symbolsToAlign});

  String name;
  int boardSize;
  int symbolsToAlign;

  Map<String, dynamic> toJson() => {
    'name': name,
    'boardSize': boardSize,
    'symbolsToAlign': symbolsToAlign
  };

  TicTacToeSettings.fromSnapshot(DataSnapshot snapshot)
      : name = snapshot.child("name").value.toString(),
        boardSize = snapshot.child("boardSize").value as int,
        symbolsToAlign = snapshot.child("symbolsToAlign").value as int;

}