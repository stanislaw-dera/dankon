import 'package:dankon/constants.dart';
import 'package:dankon/models/message.dart';
import 'package:dankon/services/database.dart';
import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({Key? key, required this.chatId, required this.databaseService}) : super(key: key);
  final DatabaseService databaseService;
  final String chatId;

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {

  final messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 32,
            color: const Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: kPrimaryColor.withOpacity(0.2),

                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                    const SizedBox(width: 20 / 4),
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        minLines: 1,
                        decoration: const InputDecoration(
                          hintText: "Type a message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(width: 20),
            IconButton(icon: const Icon(Icons.send), padding: EdgeInsets.zero, onPressed: () {
              widget.databaseService.sendMessage(Message(time: DateTime.now(), author: widget.databaseService.uid.toString(), content: messageController.text), widget.chatId);
              messageController.clear();
            },)
          ],
        ),
      ),
    );
  }
}
