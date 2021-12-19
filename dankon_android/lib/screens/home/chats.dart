import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dankon/constants.dart';
import 'package:dankon/models/chat.dart';
import 'package:dankon/screens/home/christmas_bottom_sheet.dart';
import 'package:dankon/services/database.dart';
import 'package:dankon/services/facebook_profile_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    final myUid = context.read<User?>()!.uid;
    DatabaseService databaseService = DatabaseService(uid: myUid);
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('chats')
        .where('allParticipants', arrayContains: myUid)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          physics: BouncingScrollPhysics(),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> jsonData =
                document.data()! as Map<String, dynamic>;
            jsonData["id"] = document.id;
            Chat chat = Chat.fromJson(jsonData);

            String title = chat.getChatName(myUid);
            String image = chat.getChatImageUrl(myUid);

            String streakText =
                chat.countDays() > 0 ? "🔥${chat.countDays()} " : "";

            return ListTile(
                title: Text(title),
                subtitle: Text("${chat.danks} danks! ${streakText}"),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(getAccessUrlIfFacebook(image)),
                ),
                trailing: chat.canIDank(myUid)
                    ? OutlinedButton(
                        onPressed: () {
                          databaseService.incrementDanks(
                              chat, context.read<User?>());
                        },
                        onLongPress: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return ChristmasBottomSheet();
                              });
                        },
                        child: Text('Dankon!'),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(kTextColor)),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Icon(Icons.check_circle_outline),
                      ));
          }).toList(),
        );
      },
    );
  }
}
