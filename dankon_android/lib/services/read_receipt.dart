import 'package:dankon/models/chat.dart';
import 'package:firebase_database/firebase_database.dart';

class ReadReceiptService {
  ReadReceiptService({required this.chat, required this.uid});

  final Chat chat;
  final String uid;

  FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference getReadReceiptRef() {
    return database.ref("chats/${chat.id}/read-receipt/$uid");
  }

  Future<void> updateReadReceipt() {
    return getReadReceiptRef().set(ServerValue.timestamp);
  }
}
