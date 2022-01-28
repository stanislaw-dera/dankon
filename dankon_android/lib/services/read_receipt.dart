import 'package:dankon/models/chat.dart';
import 'package:dankon/utils/timestamp_to_datetime.dart';
import 'package:firebase_database/firebase_database.dart';

class ReadReceiptService {
  ReadReceiptService({required this.chat, required this.uid});

  final Chat chat;
  final String uid;

  FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference getReadReceiptRef() {
    return database.ref("chats/${chat.id}/read-receipt");
  }

  Stream<Map<dynamic, dynamic>> get readReceiptChanges {
    return getReadReceiptRef().onValue.map((event) => event.snapshot.value as Map<dynamic, dynamic>);
  }

  DatabaseReference getMyReadReceiptRef() {
    return database.ref("chats/${chat.id}/read-receipt/$uid");
  }

  Future<void> updateReadReceipt() {
    return getMyReadReceiptRef().set(ServerValue.timestamp);
  }

  List<String> getUidsToShowReadReceipt(DateTime timeSent, DateTime? nextSentTime, Map<dynamic, dynamic> readReceiptData) {

    List<String> uidsToShowReadReceipt = [];

    if(readReceiptData.length < chat.allParticipants.length || timeSent == placeholderDateTime) return uidsToShowReadReceipt;

    for (var participant in chat.allParticipants) {
      DateTime lastReadReceiptTime = DateTime.fromMillisecondsSinceEpoch(int.parse(readReceiptData[participant].toString()));

      if(!timeSent.isAfter(lastReadReceiptTime)) {
        if(nextSentTime == null) {
          // it's the latest message
          uidsToShowReadReceipt.add(participant);
        } else if(nextSentTime.isAfter(lastReadReceiptTime)) {
          // there is more recent message
          uidsToShowReadReceipt.add(participant);
        }
      }
    }

    return uidsToShowReadReceipt;
  }

}
