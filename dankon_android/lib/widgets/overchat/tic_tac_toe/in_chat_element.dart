import 'package:dankon/models/chat.dart';
import 'package:dankon/models/chat_theme.dart';
import 'package:dankon/models/message.dart';
import 'package:dankon/widgets/overchat/tic_tac_toe/play_view.dart';
import 'package:dankon/widgets/overchat/tic_tac_toe/send.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicTacToeInChatElement extends StatelessWidget {
  const TicTacToeInChatElement(
      {Key? key,
      required this.message,
      required this.chat,
      required this.byMe,
      required this.isThereMessageAfter,
      required this.isThereMessageBefore})
      : super(key: key);

  final Message message;
  final Chat chat;
  final bool byMe;
  final bool isThereMessageAfter;
  final bool isThereMessageBefore;

  @override
  Widget build(BuildContext context) {
    Radius defaultRadius = const Radius.circular(20);
    String? winner;
    bool isEnded = false;
    ChatTheme chatTheme = context.watch<ChatTheme>();

    if (message.isPending) return const CircularProgressIndicator();

    if (message.overchatData["winner"] != null) {
      winner = chat.participantsData
          .firstWhere(
              (element) => element.uid == message.overchatData["winner"])
          .name;
    }

    if(message.overchatData["isEnded"] != null) isEnded = true;

    return Row(
      mainAxisAlignment: byMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if(isEnded) {
              sendTicTacToe(context, chat);
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlayTicTacToeView(chat: chat),
              ));
            }
          },
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              color: isEnded ? chatTheme.messageBackgroundColor : Colors.blue,
              borderRadius: BorderRadius.only(
                topRight:
                    byMe && isThereMessageBefore ? Radius.zero : defaultRadius,
                bottomRight:
                    byMe && isThereMessageAfter ? Radius.zero : defaultRadius,
                topLeft:
                    !byMe && isThereMessageBefore ? Radius.zero : defaultRadius,
                bottomLeft:
                    !byMe && isThereMessageAfter ? Radius.zero : defaultRadius,
              ),
            ),
            child: !isEnded ? Column(
              children: const [
                Text(
                  "Tic tac toe has started",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Tap to play",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ) : Text(
              winner != null ? "$winner won" : "Undecided game",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: chatTheme.messageTextColor),
            ),
          ),
        ),
      ],
    );
  }
}
