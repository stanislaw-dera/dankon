import 'package:dankon/utils/timestamp_to_datetime.dart';

class Message {
  final String? id;
  final DateTime time;
  final String author;
  final String content;
  final String type;
  final bool isPending;
  final Map<String, dynamic> overchatData;

  Map<String, dynamic> toJson() => {
        'time': time,
        'author': author,
        'content': content,
        'type': type,
        'isPending': isPending,
        'overchatData': overchatData,
      };

  Message.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        time = timestampToDateTime(json["time"], true),
        author = json["author"],
        content = json["content"],
        type = json["type"] ?? "TEXT_MESSAGE",
        isPending = json["isPending"] ?? false,
        overchatData = json["overchatData"] ?? {};

  Message(
      {this.id,
      required this.time,
      required this.author,
      required this.content,
      this.type = "TEXT_MESSAGE",
      this.isPending = false,
      this.overchatData = const {}});
}
