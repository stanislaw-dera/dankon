import 'package:dankon/constants/constants.dart';
import 'package:dankon/models/chat.dart';
import 'package:dankon/widgets/chat_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DanksPage extends StatefulWidget {
  const DanksPage({Key? key}) : super(key: key);

  @override
  _DanksPageState createState() => _DanksPageState();
}

class _DanksPageState extends State<DanksPage> {
  @override
  Widget build(BuildContext context) {
    String myUid = context.read<User?>()!.uid;
    List<Chat>? chats = context.watch<List<Chat>?>();
    Map<String, DateTime> unreadMessagesData = context.watch<Map<String, DateTime>>();

    return chats == null ? const Center(child: CircularProgressIndicator(),) : ListView(
          physics: const BouncingScrollPhysics(),
          children: chats.map((Chat chat) {

            String title = chat.getChatName(myUid);
            String image = chat.getChatImageUrl(myUid);
            bool unreadMessages = unreadMessagesData[chat.id] != null && unreadMessagesData[chat.id]!.isBefore(chat.lastMessageTime);

              String subtitle =
                  chat.countDays() > 0 && !chat.startNewDankstreak()
                      ? "${chat.danks} danks! 🔥${chat.countDays()} "
                      : "${chat.danks} danks!";

              return ChatTile(
                  subtitle: subtitle,
                  title: title,
                  imageUrl: image,
                  isHighlighted: unreadMessages,
                  trailing: chat.canIDank(myUid)
                      ? OutlinedButton(
                          onPressed: () {
                            chat.incrementDanks(myUid);
                          },
                          child: const Text('Dankon!'),
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(kDarkColor)),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(right: 30.0),
                          child: Icon(Icons.check_circle_outline),
                        ));
            }).toList(),
          );
  }
}
