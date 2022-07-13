import 'dart:async';

import 'package:dankon/models/chat.dart';
import 'package:dankon/widgets/overchat/tic_tac_toe/models/move.dart';
import 'package:dankon/widgets/overchat/tic_tac_toe/models/settings.dart';
import 'package:dankon/widgets/overchat/tic_tac_toe/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dankon/widgets/overchat//tic_tac_toe/models/player.dart';

class PlayTicTacToeView extends StatefulWidget {
  const PlayTicTacToeView({Key? key, required this.chat}) : super(key: key);
  final Chat chat;

  @override
  State<PlayTicTacToeView> createState() => _PlayTicTacToeViewState();
}

class _PlayTicTacToeViewState extends State<PlayTicTacToeView> {
  bool isLoading = true;
  bool isLocked = false;

  String myUid = FirebaseAuth.instance.currentUser!.uid;

  late TicTacToeSettings gameSettings;

  String currentPlayer = Player.none;
  String myPlayer = Player.X;
  late StreamSubscription gameHistoryChanges;

  late List<List<String>> board;

  @override
  void initState() {
    super.initState();
    prepareTheGame();
  }

  @override
  void dispose() {
    super.dispose();
    gameHistoryChanges.cancel();
  }

  void prepareTheGame() async {
    DatabaseReference gameRef =
        FirebaseDatabase.instance.ref("games/tic-tac-toe/${widget.chat.id}");
    final event = await gameRef.once(DatabaseEventType.value);
    Map data = event.snapshot.value as Map;

    String _myPlayer = Player.none;
    if (data["playerX"] == myUid) {
      _myPlayer = Player.X;
    } else {
      _myPlayer = Player.O;
    }

    List<List<dynamic>> boardData = List.from(data["board"] as List);

    setState(() {
      board = boardData
          .map((nestedL) => nestedL.map((e) => e.toString()).toList())
          .toList();
      gameSettings =
          TicTacToeSettings.fromSnapshot(event.snapshot.child("settings"));
      myPlayer = _myPlayer;
      isLoading = false;
      currentPlayer = !event.snapshot.child("history").exists ? Player.X : Player.none;
    });

    setState(() {
      gameHistoryChanges =
          gameRef.child("history").onChildAdded.listen((event) {
        TicTacToeMove move = TicTacToeMove.fromSnapshot(event.snapshot);

        setState(() {
          board[move.x][move.y] = move.player;
        });

        String? winner;
        if (move.isWinning(board, gameSettings)) {
          winner = move.player;
        }

        if (TicTacToeUtils.isEnd(board) || winner != null) {
          finishGame(winner);
        }

        String _currentPlayer = Player.X;
        if (move.player == Player.X) _currentPlayer = Player.O;
        setState(() {
          currentPlayer = _currentPlayer;
        });
      });
    });
  }

  void finishGame(String? winner) async {
    setState(() {
      isLocked = true;
    });

    String? winnerUid;
    if(winner != null) {
      if(winner == myPlayer) {
        winnerUid = myUid;
      } else {
        winnerUid = widget.chat.participantsData.firstWhere((theUser) => theUser.uid != myUid).uid;
      }
    }

    DatabaseReference gameStatusRef = FirebaseDatabase.instance
        .ref("games/tic-tac-toe/${widget.chat.id}");
    await gameStatusRef.update({
      "isEnded": true,
      "winner": winnerUid
    });

    showModalBottomSheet(
        context: context,
        backgroundColor: winner != null
            ? winner == myPlayer
                ? Colors.green
                : Colors.red
            : Colors.amber,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      winner != null
                          ? winner == myPlayer
                              ? "You won!"
                              : "Player $winner won!"
                          : "Undecided game",
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Back to Dankon",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ));
  }

  void selectField(String value, int x, int y) {
    if (value == Player.none && currentPlayer == myPlayer && isLocked == false) {
      List<List<String>> _board = board;
      _board[x][y] = myPlayer;

      DatabaseReference gameRef =
          FirebaseDatabase.instance.ref("games/tic-tac-toe/${widget.chat.id}");
      gameRef.update({
        "/board": _board,
      });

      DatabaseReference historyLogRef = gameRef.child("/history").push();
      historyLogRef.set(TicTacToeMove(x, y, myPlayer).toJson());
    } else  {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isLocked ? "Board is locked" : "It's not your turn")));
    }
  }

  Widget buildField(int x, int y) {
    double fontSize =
        (MediaQuery.of(context).size.width - 20 - 8 * gameSettings.boardSize) /
            gameSettings.boardSize /
            2;

    final value = board[x][y];
    final color = TicTacToeUtils.getFieldColor(value);

    return Container(
      margin: const EdgeInsets.all(4),
      child: AspectRatio(
        aspectRatio: 1,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: color, padding: EdgeInsets.zero),
          child: Text(value,
              style:
                  TextStyle(fontSize: fontSize, height: 0, letterSpacing: 0)),
          onPressed: () {
            selectField(value, x, y);
          },
        ),
      ),
    );
  }

  Widget buildCol(List<List<String>> board, int x) {
    final values = board[x];

    return Expanded(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: TicTacToeUtils.modelBuilder(
        values,
        (y, value) => buildField(x, y),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TicTacToeUtils.getBackgroundColor(currentPlayer),
      body: isLoading || currentPlayer == Player.none
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
            child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Player $currentPlayer turn", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    Expanded(
                      child: Row(
                        children: TicTacToeUtils.modelBuilder(
                            board, (x, value) => buildCol(board, x)),
                      ),
                    ),
                  ],
                ),
              ),
          ),
    );
  }
}
