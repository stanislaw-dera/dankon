import 'package:dankon/widgets/overchat/tic_tac_toe/models/settings.dart';
import 'package:dankon/widgets/overchat/tic_tac_toe/utils/game_helpers.dart';
import 'package:firebase_database/firebase_database.dart';

class TicTacToeMove {
  TicTacToeMove(this.x, this.y, this.player);

  int x;
  int y;
  String player;

  bool isWinning(List<List<String>> board, TicTacToeSettings settings) {
    var col = 0, row = 0, diag = 0, rDiag = 0;

    final diagStartPoint = GameHelpers.getDiagStartPoint(x, y);
    final rDiagStartPoint = GameHelpers.getRDiagStartPoint(settings.boardSize, x, y);

    final n = settings.boardSize;

    for (int i = 0; i < n; i++) {
      // col check
      if (board[x][i] == player) {
        col++;
      } else {
        col = 0;
      }
      // row check
      if (board[i][y] == player) {
        row++;

      } else {
        row = 0;
      }
      // diag check
      if(diagStartPoint["x"]!+i < n && diagStartPoint["y"]!+i < n) {
        if (board[diagStartPoint["x"]!+i][diagStartPoint["y"]!+i] == player) {
          diag++;
        } else {
          diag = 0;
        }
      }
      // rDiag check
      if(rDiagStartPoint["x"]!+i < n && rDiagStartPoint["y"]!-i >= 0) {
        if (board[rDiagStartPoint["x"]!+i][rDiagStartPoint["y"]!-i] == player) {
          rDiag++;
        } else {
          rDiag = 0;
        }
      }

      if(row >= settings.symbolsToAlign || col >= settings.symbolsToAlign || diag >= settings.symbolsToAlign || rDiag >= settings.symbolsToAlign) {
        return true;
      }
    }

    return row >= settings.symbolsToAlign || col >= settings.symbolsToAlign || diag >= settings.symbolsToAlign || rDiag >= settings.symbolsToAlign;
  }

  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
    'player': player
  };

  TicTacToeMove.fromSnapshot(DataSnapshot snapshot)
      : x = snapshot.child("x").value as int,
        y = snapshot.child("y").value as int,
        player = snapshot.child("player").value as String;
}