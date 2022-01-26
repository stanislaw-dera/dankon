import 'package:dankon/utils/timestamp_to_datetime.dart';

class Message {
  final DateTime time;
  final String author;
  final String content;
  final String type;

  Map<String, dynamic> toJson() => {
    'time': time,
    'author': author,
    'content': content,
    'type': type
  };

  Message.fromJson(Map<String, dynamic> json)
      : time = timestampToDateTime(json["time"]),
        author = json["author"],
        content = json["content"],
        type = json["type"] ?? "TEXT_MESSAGE";

  Message({required this.time, required this.author, required this.content, this.type = "TEXT_MESSAGE"});

}
