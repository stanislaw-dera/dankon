import 'package:dankon/models/chat.dart';
import 'package:dankon/models/response.dart';
import 'package:dankon/models/the_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:characters/characters.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        urlAvatar: documentSnapshot.get('urlAvatar'));
  }

  Future<String> createChat(TheUser member) async {
    TheUser? me = await getUserByUid(uid);

    if(me!.uid == member.uid) {
      return "You cannot chat with yourself";
    }

    QuerySnapshot theSameChat = await chatsCollection.where('allParticipants', whereIn: [[member.uid, me.uid], [me.uid, member.uid]]).get();
    if(theSameChat.docs.isNotEmpty) {
      return "The same chat already exists";
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

  Future<Response> incrementDanks(Chat chat, User? me) async {

    Map<String, dynamic> updateData = {
      'danks': FieldValue.increment(1),
      'lastDankAuthor': me!.uid,
      'lastDankTime': FieldValue.serverTimestamp()
    };

    // update lastDankstreakTime
    DateTime last = DateTime.utc(chat.lastDankTime.year, chat.lastDankTime.month, chat.lastDankTime.day);
    int difference = DateTime.now().difference(last).inDays;
    if(difference == 0) {
      updateData["lastDankstreakTime"] = FieldValue.serverTimestamp();
    }

    // start a new dankstreak if the previous one has expired
    if(chat.startNewDankstreak()) {
      updateData["dankstreakFrom"] = FieldValue.serverTimestamp();
    }

    await chatsCollection.doc(chat.id).update(updateData);

    return Response(type: 'success');
  }

  Future<Response> setChristmasBadge(Chat chat, String christmasBadge) async {
    await chatsCollection.doc(chat.id).update({
      'christmasBadge': christmasBadge
    });
    return Response(type: 'success');
  }

  Future<Response> saveNotificationsToken(String token) async {
    await usersCollection.doc(uid).update({
      'notificationsTokens': FieldValue.arrayUnion([token])
    });
    return Response(type: "success");
  }
}
