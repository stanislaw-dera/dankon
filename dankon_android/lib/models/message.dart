class Message {
  final DateTime time;
  final String author;
  final String content;

  Message({required this.time, required this.author, required this.content});
}

// Example messages for testing
final List<Message> placeholderMessages = [
  Message(time: DateTime.now(), author: "user1uid", content: "What's app?"),
  Message(time: DateTime.now(), author: "user2uid", content: "Hi!"),
  Message(time: DateTime.now(), author: "user1uid", content: "Hello world!"),
];
