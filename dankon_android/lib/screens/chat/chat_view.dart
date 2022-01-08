import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dankon/constants/chat_themes.dart';
import 'package:dankon/models/chat.dart';
import 'package:dankon/models/chat_theme.dart';
import 'package:dankon/models/message.dart';
import 'package:dankon/services/database.dart';
import 'package:dankon/widgets/cached_avatar.dart';
import 'package:dankon/widgets/message_bubble.dart';
import 'package:dankon/widgets/message_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {

  ChatTheme chatTheme = getChatThemeById("dark-forest-green");
  
  void changeTheme(String id) {
    setState(() {
      chatTheme = getChatThemeById(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    String myUid = context.read<User?>()!.uid;
    final Chat chat = ModalRoute.of(context)!.settings.arguments as Chat;

    final Stream<QuerySnapshot> messagesStream = FirebaseFirestore.instance
        .collection("chats/${chat.id}/messages")
        .orderBy("time", descending: true)
        .snapshots();

    return Provider<ChatTheme>.value(
      value: chatTheme,
      child: Scaffold(
          backgroundColor: chatTheme.backgroundColor,
          appBar: buildAppBar(chat, myUid, chatTheme),
          body: StreamBuilder<QuerySnapshot>(
            stream: messagesStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<Message> messages = snapshot.data!.docs.map((doc) {
                Map<String, dynamic> jsonData =
                    doc.data() as Map<String, dynamic>;
                return Message.fromJson(jsonData);
              }).toList();

              return Column(
                children: [
                  Expanded(
                    child: messages.isEmpty
                        ? ChatWelcome(
                            photoUrl: chat.getChatImageUrl(myUid),
                            title: chat.getChatName(myUid))
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: ListView.builder(
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                return MessageBuble(
                                  msg: messages[index],
                                  byMe: messages[index].author == myUid,
                                );
                              },
                            ),
                          ),
                  ),
                  MessageInput(chatId: chat.id, databaseService: DatabaseService(uid: myUid),)
                ],
              );
            },
          )),
    );
  }
}

AppBar buildAppBar(Chat chat, String myUid, ChatTheme chatTheme) {
  return AppBar(
    centerTitle: false,
    titleSpacing: 0,
    backgroundColor: chatTheme.secondaryColor,
    foregroundColor: chatTheme.textColor,
    title: Row(
      children: [
        CachedAvatar(
          url: chat.getChatImageUrl(myUid),
          radius: 15,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(chat.getChatName(myUid)),
      ],
    ),
    actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.info))],
  );
}

class ChatWelcome extends StatelessWidget {
  final String photoUrl;
  final String title;

  const ChatWelcome({Key? key, required this.photoUrl, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    ChatTheme chatTheme = context.read<ChatTheme>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedAvatar(
          url: photoUrl,
          radius: 30,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 20, color: chatTheme.textColor),
        ),
        const SizedBox(
          height: 5,
        ),
        Text("Your chat with $title starts here", style: TextStyle(color: chatTheme.textColor),),
      ],
    );
  }
}
