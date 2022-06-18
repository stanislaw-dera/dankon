import 'package:dankon/constants/chat_themes.dart';
import 'package:dankon/models/chat.dart';
import 'package:dankon/models/chat_theme.dart';
import 'package:dankon/screens/tic_tac_toe/start_bottom_sheet.dart';
import 'package:dankon/services/database.dart';
import 'package:dankon/services/read_receipt.dart';
import 'package:dankon/widgets/cached_avatar.dart';
import 'package:dankon/widgets/message_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showFriendBottomSheet(Chat chat, BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FriendBottomSheet(chat: chat);
      });
}

Widget buildOverlappingAvatars(Chat chat, User? me) => SizedBox(
      width: 36 + 36 + 50,
      child: Stack(
        children: <Widget>[
          Positioned(
            child: CachedAvatar(
              url: me!.photoURL.toString(),
              radius: 36,
            ),
          ),
          Positioned(
            left: 50,
            child: CachedAvatar(
              url: chat.getChatImageUrl(me.uid),
              radius: 36,
            ),
          ),
        ],
      ),
    );

class FriendBottomSheet extends StatelessWidget {
  const FriendBottomSheet({Key? key, required this.chat}) : super(key: key);
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    User? me = context.read<User?>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildOverlappingAvatars(chat, me),
          const SizedBox(
            height: 20,
          ),
          Text(
            "You and ${chat.getChatName(me!.uid).split(" ")[0]}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              child: Provider<ChatTheme>.value(
                  value: getChatThemeById("default"),
                  child: MessageInput(
                      chatId: chat.id,
                      databaseService: DatabaseService(uid: me.uid),
                      onMessageSent: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Message sent!")));
                        ReadReceiptService(chat: chat, uid: me.uid).updateReadReceipt();
                        Navigator.of(context).pop();
                      },
                  ))),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: () {
            Navigator.of(context).pop();
            showModalBottomSheet(context: context, builder: (context) {
              return StartTicTacToeBottomSheet(chat: chat);
            });
          }, child: const Text("Start tic tac toe")),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: const SizedBox(
              height: 20,
            ),
          ),

        ],
      ),
    );
  }
}
