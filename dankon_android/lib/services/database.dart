import 'package:dankon/models/the_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:characters/characters.dart';

class DatabaseService {

  final String? uid;
  DatabaseService({this.uid});
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(TheUser theUser) async {

    var userJSON = theUser.toJson();
    var searchIndex = [];

    for(var i = 1; i<=theUser.name.length; i++) {
      searchIndex.add(theUser.name.characters.take(i).toLowerCase().toString());
    }

    userJSON.addAll({"search": searchIndex});
    
    print(userJSON);

    await usersCollection.doc(theUser.uid).set(userJSON, SetOptions(merge: true),);
  }
}