import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dankon/models/chat.dart';
import 'package:dankon/models/chat_theme.dart';
import 'package:dankon/models/message.dart';
import 'package:dankon/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

import 'chat_view.dart';

class PaginatedMessagesList extends StatelessWidget {
  const PaginatedMessagesList({Key? key, required this.chat}) : super(key: key);
  final Chat chat;

  @override
  Widget build(BuildContext context) {

    String myUid = context.read<User?>()!.uid;
    ChatTheme chatTheme = context.read<ChatTheme>();
    final Query messagesQuery = FirebaseFirestore.instance
        .collection("chats/${chat.id}/messages")
        .orderBy("time", descending: true);


    return PaginateFirestore(
      query: messagesQuery,
      itemBuilderType: PaginateBuilderType.listView,
      reverse: true,
      physics: const BouncingScrollPhysics(),
      isLive: true,
      itemBuilder:
          (context, documentSnapshots, index) {
        final json = documentSnapshots[index].data() as Map<String,dynamic>;
        final Message message = Message.fromJson(json);

        return MessageBuble(byMe: message.author == myUid, msg: message,);
      },
      onEmpty: ChatWelcome(photoUrl: chat.getChatImageUrl(myUid), title: chat.getChatName(myUid)),
      initialLoader: Center(child: CircularProgressIndicator(color: chatTheme.secondaryColor,)),
      bottomLoader: Center(child: CircularProgressIndicator(color: chatTheme.secondaryColor,)),
    );
  }
}