import 'package:dankon/models/chat.dart';
import 'package:dankon/widgets/cached_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showFriendBottomSheet(Chat chat, BuildContext context) {
  showModalBottomSheet(
      context: context,
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
        children: [
          buildOverlappingAvatars(chat, me),
          const SizedBox(
            height: 20,
          ),
          Text(
            "You and ${chat.getChatName(me!.uid).split(" ")[0]}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
