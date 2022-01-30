import 'package:dankon/models/chat.dart';
import 'package:dankon/widgets/chat_tile.dart';
import 'package:dankon/widgets/new_messages_chip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String myUid = context.read<User?>()!.uid;
    List<Chat>? chats = context.watch<List<Chat>?>();

    Map<String, DateTime> unreadMessagesData = context.watch<Map<String, DateTime>>();

    if(chats == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      chats.sort((a,b) => b.lastMessageTime.compareTo(a.lastMessageTime));
      return ListView(
        physics: const BouncingScrollPhysics(),
        children: chats.map((Chat chat) {

          String title = chat.getChatName(myUid);
          String image = chat.getChatImageUrl(myUid);
          bool isHighlighted = unreadMessagesData[chat.id] != null && unreadMessagesData[chat.id]!.isBefore(chat.lastMessageTime);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ChatTile(
              title: title,
              isHighlighted: isHighlighted,
              trailing: isHighlighted ? const NewMessagesChip() : null,
              subtitle: chat.lastMessageContent != "" ? "${chat.lastMessageAuthor}: ${chat.lastMessageContent}" : null,
              imageUrl: image,
              onPressed: () {
                Navigator.pushNamed(context, "/chat", arguments: chat);
              },
            ),
          );
        }).toList(),
      );
    }

  }
}
