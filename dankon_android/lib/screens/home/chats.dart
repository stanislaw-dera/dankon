import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dankon/constants.dart';
import 'package:dankon/models/chat.dart';
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
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('chats').where('allParticipants', arrayContains: myUid).snapshots();

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

            Chat chat =  Chat.fromJson(document.data()! as Map<String, dynamic>);

            String title = chat.getChatName(myUid);
            String image = chat.getChatImageUrl(myUid);

            return ListTile(
              title: Text(title),
              subtitle: Text("${chat.danks} danks!"),
              leading: CircleAvatar(backgroundImage: NetworkImage(getAccessUrlIfFacebook(image)),),
              trailing: OutlinedButton(onPressed: () {
                databaseService.incrementDanks(document.id);
              },
              child: Text('Dankon!'),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(kTextColor)
                ),
            ));
          }).toList(),
        );
      },
    );
  }
}

