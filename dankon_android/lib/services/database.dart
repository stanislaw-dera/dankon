import 'package:dankon/models/the_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:characters/characters.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection('chats');

  Future<void> createUser(TheUser theUser) async {
    var userJSON = theUser.toJson();
    var searchIndex = [];

    for (var i = 1; i <= theUser.name.length; i++) {
      searchIndex.add(theUser.name.characters.take(i).toLowerCase().toString());
    }

    userJSON.addAll({"search": searchIndex});

    print(userJSON);

    await usersCollection.doc(theUser.uid).set(
          userJSON,
          SetOptions(merge: true),
        );
  }

  Future<TheUser?> getUserByUid(userUid) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();

    return TheUser(
        uid: documentSnapshot.get('uid'),
        name: documentSnapshot.get('name'),
        urlAvatar: documentSnapshot.get('urlAvatar'),
        bio: documentSnapshot.get('bio'));
  }

  Future<String> createChat(TheUser member) async {
    TheUser? me = await getUserByUid(uid);

    if(me!.uid == member.uid) {
      return "You cannot chat with yourself";
    }


    List participantsData = [
      member.toJson(),
      me.toJson()
    ];

    await chatsCollection.add({'name': 'New chatroom', 'allParticipants': [
      me.uid,
      member.uid
    ], 'participantsData': participantsData, 'danks': 0});

    return "Created a chat";
  }

  Future<void> incrementDanks(chatId) async {
    chatsCollection.doc(chatId).update({
      'danks': FieldValue.increment(1)
    });
  }
}
