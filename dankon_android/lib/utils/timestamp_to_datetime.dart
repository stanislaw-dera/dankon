import 'package:cloud_firestore/cloud_firestore.dart';

DateTime placeholderDateTime = DateTime(2000);

DateTime timestampToDateTime(dynamic timestamp, [bool defaultNow = false]) {

  DateTime defaultDateTime = defaultNow ? DateTime.now() : placeholderDateTime;

  if (timestamp == null) {
    return defaultDateTime;
  }

  Timestamp t = timestamp;
  DateTime d = t.toDate();
  return d;
}