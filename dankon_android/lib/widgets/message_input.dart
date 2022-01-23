import 'package:dankon/models/chat_theme.dart';
import 'package:dankon/models/message.dart';
import 'package:dankon/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    ChatTheme chatTheme = context.watch<ChatTheme>();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
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
                  color: chatTheme.secondaryColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(color: chatTheme.textColor),
                        maxLines: 4,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: chatTheme.textColor.withOpacity(0.5)),

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(width: 20),
            IconButton(icon: Icon(Icons.send, color: chatTheme.buttonsColor,), padding: EdgeInsets.zero, onPressed: () {
              if(messageController.text.isNotEmpty) {
                widget.databaseService.sendMessage(Message(time: DateTime.now(), author: widget.databaseService.uid.toString(), content: messageController.text), widget.chatId);
                messageController.clear();
              }
            },)
          ],
        ),
      ),
    );
  }
}
