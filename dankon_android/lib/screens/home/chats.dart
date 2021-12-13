import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dankon/constants.dart';
import 'package:dankon/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('chats').snapshots();


  @override
  Widget build(BuildContext context) {

    final myUid = context.read<User?>()!.uid;
    DatabaseService databaseService = DatabaseService(uid: myUid);

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
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

            String title = '';
            String image = '';
            for(var i = 0; i<data['participantsData'].length; i++) {
              if(data['participantsData'][i]['uid'] != myUid) {
                title = data['participantsData'][i]['name'];
                image = data['participantsData'][i]['urlAvatar'];
              }

            }

            return ListTile(
              title: Text(title),
              subtitle: Text("${data["danks"].toString()} danks!"),
              leading: CircleAvatar(backgroundImage: NetworkImage(image),),
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

