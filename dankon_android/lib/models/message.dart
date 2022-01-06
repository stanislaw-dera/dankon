import 'package:dankon/utils/timestamp_to_datetime.dart';

class Message {
  final DateTime time;
  final String author;
  final String content;

  Map<String, dynamic> toJson() => {
    'time': time,
    'author': author,
    'content': content
  };

  Message.fromJson(Map<String, dynamic> json)
      : time = timestampToDateTime(json["time"]),
        author = json["author"],
        content = json["content"];

  Message({required this.time, required this.author, required this.content});

}
