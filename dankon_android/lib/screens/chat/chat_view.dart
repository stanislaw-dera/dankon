import 'package:dankon/models/chat.dart';
import 'package:dankon/widgets/cached_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {

    String myUid = context.read<User?>()!.uid;
    final Chat chat = ModalRoute.of(context)!.settings.arguments as Chat;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            CachedAvatar(url: chat.getChatImageUrl(myUid), radius: 15,),
            const SizedBox(width: 10,),
            Text(chat.getChatName(myUid)),
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.info))],
      ),
    );
  }
}
