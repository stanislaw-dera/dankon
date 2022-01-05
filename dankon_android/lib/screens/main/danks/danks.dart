import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dankon/constants.dart';
import 'package:dankon/models/chat.dart';
import 'package:dankon/services/database.dart';
import 'package:dankon/services/facebook_profile_images.dart';
import 'package:dankon/widgets/cached_avatar.dart';
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

    return chats == null ? const Center(child: CircularProgressIndicator(),) : ListView(
          physics: const BouncingScrollPhysics(),
          children: chats.map((Chat chat) {

            String title = chat.getChatName(myUid);
            String image = chat.getChatImageUrl(myUid);

            String streakText =
                chat.countDays() > 0 && !chat.startNewDankstreak() ? "🔥${chat.countDays()} " : "";

            print(title);
            print("\t Show? ${!chat.startNewDankstreak() ? "tak" : "nie"}");
            print("\t Days? ${chat.countDays().toString()}");

            return ListTile(
                title: Text(title),
                subtitle: Text("${chat.danks} danks! $streakText"),
                leading: CachedAvatar(url: getAccessUrlIfFacebook(image),),
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
