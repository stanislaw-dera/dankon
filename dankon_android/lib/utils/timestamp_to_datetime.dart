import 'package:cloud_firestore/cloud_firestore.dart';

DateTime timestampToDateTime(dynamic timestamp) {
  if (timestamp == null) {
    return DateTime(2000);
  }

  Timestamp t = timestamp;
  DateTime d = t.toDate();
  return d;
}