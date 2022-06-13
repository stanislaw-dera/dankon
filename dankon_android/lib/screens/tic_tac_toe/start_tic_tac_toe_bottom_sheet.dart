import 'package:dankon/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:dankon/models/tic_tac_toe_settings.dart';

class StartTicTacToeBottomSheet extends StatefulWidget {
  const StartTicTacToeBottomSheet({Key? key}) : super(key: key);

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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: isLoading ? Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 20,),
          Text("Sit tight! We're starting the game...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ],
      ) : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Play tic tac toe",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5,),
          const Text("What should the board size be?"),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: presets.map((preset) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: OutlinedButton(
                onPressed: () async {
                  changeIsLoading(true);
                  // TODO: Create game in DB
                  await Future.delayed(const Duration(seconds: 3));
                  changeIsLoading(false);
                  // TODO: Push to game screen
                },
                child: Text(preset.name),
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all(kDarkColor)),
              ),
            )).toList()
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}
