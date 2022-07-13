import 'package:dankon/constants/constants.dart';
import 'package:dankon/models/chat.dart';
import 'package:dankon/models/message.dart';
import 'package:dankon/services/database.dart';
import 'package:dankon/widgets/overchat/tic_tac_toe/play_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dankon/widgets/overchat/tic_tac_toe/models/settings.dart';
import 'package:provider/provider.dart';

class StartTicTacToeBottomSheet extends StatefulWidget {
  const StartTicTacToeBottomSheet({Key? key, required this.chat})
      : super(key: key);

  final Chat chat;

  @override
  State<StartTicTacToeBottomSheet> createState() =>
      _StartTicTacToeBottomSheetState();
}

class _StartTicTacToeBottomSheetState extends State<StartTicTacToeBottomSheet> {
  bool isLoading = false;

  void changeIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  List<TicTacToeSettings> presets = [
    TicTacToeSettings(name: "3x3", symbolsToAlign: 3, boardSize: 3),
    TicTacToeSettings(name: "5x5", symbolsToAlign: 4, boardSize: 5),
    TicTacToeSettings(name: "7x7", symbolsToAlign: 4, boardSize: 7),
  ];

  @override
  void initState() {
    super.initState();
    prepareToStart();
  }

  void prepareToStart() async {
    changeIsLoading(true);
    DatabaseReference gameRef =
        FirebaseDatabase.instance.ref("games/tic-tac-toe/${widget.chat.id}");
    final snapshot = await gameRef.get();

    if (snapshot.exists && snapshot.child("isEnded").value != true) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PlayTicTacToeView(chat: widget.chat),
        ),
      );
    } else {
      changeIsLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    User? me = context.read<User?>();
    DatabaseService databaseService = DatabaseService(uid: me!.uid);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: isLoading
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text("Setting things up...",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Play tic tac toe",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text("Choose size of the board"),
                const SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: presets
                        .map((preset) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: OutlinedButton(
                                onPressed: () async {
                                  changeIsLoading(true);
                                  // prepare tic tac toe message
                                  Message msg = Message(
                                      time: DateTime.now(),
                                      author: me.uid,
                                      content: "Tic tac toe started",
                                      type: "TIC_TAC_TOE/DEFAULT",
                                      isPending: true,
                                      overchatData: preset.toJson());
                                  // send message
                                  await databaseService.sendMessage(
                                      msg, widget.chat.id);
                                  changeIsLoading(false);
                                  // redirect user to chat
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      "/chat", ModalRoute.withName('/'),
                                      arguments: widget.chat);
                                },
                                child: Text(preset.name),
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(kDarkColor)),
                              ),
                            ))
                        .toList()),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
    );
  }
}
