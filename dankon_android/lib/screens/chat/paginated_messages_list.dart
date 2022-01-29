import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dankon/models/chat.dart';
import 'package:dankon/models/chat_theme.dart';
import 'package:dankon/models/message.dart';
import 'package:dankon/screens/chat/chat_element_chooser.dart';
import 'package:dankon/services/read_receipt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_cubit.dart';
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

    final ReadReceiptService readReceiptService = ReadReceiptService(chat: chat, uid: myUid);

    return StreamProvider<Map<dynamic, dynamic>>(
      create: (context) => readReceiptService.readReceiptChanges,
      initialData: const {},
      child: PaginateFirestore(
        query: messagesQuery,
        itemBuilderType: PaginateBuilderType.listView,
        reverse: true,
        physics: const BouncingScrollPhysics(),
        isLive: true,
        onLoaded: (PaginationLoaded paginationLoaded) {
          readReceiptService.updateReadReceipt();
        },
        itemBuilder:
            (context, documentSnapshots, index) {

          final messageJson = documentSnapshots[index].data() as Map<String,dynamic>;
          messageJson["id"] = documentSnapshots[index].id;
          final Message message = Message.fromJson(messageJson);

          final previousMessageJson = documentSnapshots.asMap().containsKey(index + 1) ? documentSnapshots[index + 1].data() : null;
          final Message? previousMessage = previousMessageJson != null ? Message.fromJson(previousMessageJson as Map<String,dynamic>) : null;

          final nextMessageJson = documentSnapshots.asMap().containsKey(index - 1) ? documentSnapshots[index - 1].data() : null;
          final Message? nextMessage = nextMessageJson != null ? Message.fromJson(nextMessageJson as Map<String,dynamic>) : null;

          return ChatElementChooser(message: message, previousMessage: previousMessage, nextMessage: nextMessage,);
        },
        onEmpty: ChatWelcome(photoUrl: chat.getChatImageUrl(myUid), title: chat.getChatName(myUid)),
        initialLoader: Center(child: CircularProgressIndicator(color: chatTheme.secondaryColor,)),
        bottomLoader: Center(child: CircularProgressIndicator(color: chatTheme.secondaryColor,)),
      ),
    );
  }
}