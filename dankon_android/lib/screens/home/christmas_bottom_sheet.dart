import 'package:dankon/models/chat.dart';
import 'package:dankon/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class ChristmasChoice extends StatelessWidget {

  final String emoji;
  final Chat chat;

  const ChristmasChoice({Key? key, required this.emoji, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final myUid = context.read<User?>()!.uid;
    DatabaseService databaseService = DatabaseService(uid: myUid);

    return Card(
      child: InkWell(
          onTap: () {
            // set chat badge
            databaseService.setChristmasBadge(chat, emoji);
            Navigator.pop(context);
          },
          child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 20),
              ))),
    );
  }
}


class ChristmasBottomSheet extends StatelessWidget {

  final Chat chat;

  const ChristmasBottomSheet({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Column(
          children: [
            const Text(
              'Merry Christmas!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              "Choose special christmas badge for your chat! Available for limited time",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 4,
                children: [
                  ChristmasChoice(emoji: "🎄", chat: chat),
                  ChristmasChoice(emoji: "🎀", chat: chat),
                  ChristmasChoice(emoji: "⭐", chat: chat),
                  ChristmasChoice(emoji: "🧦", chat: chat),
                  ChristmasChoice(emoji: "🔥", chat: chat),
                  ChristmasChoice(emoji: "☃", chat: chat),
                  ChristmasChoice(emoji: "🎁", chat: chat),
                  ChristmasChoice(emoji: "🕯️", chat: chat)
                ],
              ),
            ),
          ],
        ));
  }
}
