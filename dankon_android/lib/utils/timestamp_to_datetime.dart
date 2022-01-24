import 'package:cloud_firestore/cloud_firestore.dart';

DateTime placeholderDateTime = DateTime(2000);

DateTime timestampToDateTime(dynamic timestamp) {
  if (timestamp == null) {
    return placeholderDateTime;
  }

  Timestamp t = timestamp;
  DateTime d = t.toDate();
  return d;
}