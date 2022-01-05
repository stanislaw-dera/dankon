import 'package:dankon/models/chat.dart';
import 'package:dankon/widgets/chat_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String myUid = context.read<User?>()!.uid;
    List<Chat>? chats = context.watch<List<Chat>?>();

    return chats == null ? const Center(child: CircularProgressIndicator(),) : ListView(
      physics: const BouncingScrollPhysics(),
      children: chats.map((Chat chat) {

        String title = chat.getChatName(myUid);
        String image = chat.getChatImageUrl(myUid);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ChatTile(
              title: title,
              imageUrl: image,
          ),
        );
      }).toList(),
    );
  }
}
