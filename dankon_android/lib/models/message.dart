import 'package:dankon/utils/timestamp_to_datetime.dart';

class Message {
  final String? id;
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
      : id = json["id"],
        time = timestampToDateTime(json["time"]),
        author = json["author"],
        content = json["content"],
        type = json["type"] ?? "TEXT_MESSAGE";

  Message({this.id, required this.time, required this.author, required this.content, this.type = "TEXT_MESSAGE"});

}
