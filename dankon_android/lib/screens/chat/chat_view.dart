import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dankon/constants.dart';
import 'package:dankon/models/chat.dart';
import 'package:dankon/models/message.dart';
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
  @override
  Widget build(BuildContext context) {
    String myUid = context.read<User?>()!.uid;
    final Chat chat = ModalRoute.of(context)!.settings.arguments as Chat;

    final Stream<QuerySnapshot> messagesStream = FirebaseFirestore.instance
        .collection("chats/${chat.id}/messages")
        .orderBy("time", descending: true)
        .snapshots();

    return Scaffold(
        backgroundColor: kSecondaryColor,
        appBar: buildAppBar(chat, myUid),
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
                const MessageInput()
              ],
            );
          },
        ));
  }
}

AppBar buildAppBar(Chat chat, String myUid) {
  return AppBar(
    centerTitle: false,
    titleSpacing: 0,
    backgroundColor: kPrimaryColor,
    foregroundColor: kDarkColor,
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
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 5,
        ),
        Text("Your chat with $title starts here"),
      ],
    );
  }
}
