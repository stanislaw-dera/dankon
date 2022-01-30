import 'package:firebase_database/firebase_database.dart';

class UnreadMessagesService {
  final String uid;

  UnreadMessagesService(this.uid);

  FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference getUnreadMessagesDataRef() {
    return database.ref("unread_messages_data/$uid");
  }

  Stream<Map<String, DateTime>> get unreadMessagesData {
    return getUnreadMessagesDataRef().onValue.map((event) {
      Map<String, dynamic> data = Map<String, dynamic>.from(event.snapshot.value as Map<dynamic, dynamic>);
      Map<String, DateTime> unreadMessagesData = {};

     data.forEach((key, value) {
       unreadMessagesData.addAll({key: DateTime.fromMillisecondsSinceEpoch(value)});
     });

      return unreadMessagesData;
    });
  }
}