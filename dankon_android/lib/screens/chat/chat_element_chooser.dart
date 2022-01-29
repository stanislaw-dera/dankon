import 'package:dankon/models/chat.dart';
import 'package:dankon/models/message.dart';
import 'package:dankon/services/read_receipt.dart';
import 'package:dankon/widgets/cached_avatar.dart';
import 'package:dankon/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatElementChooser extends StatelessWidget {
  const ChatElementChooser(
      {Key? key,
      required this.message,
      this.previousMessage,
      this.nextMessage})
      : super(key: key);


  final Message message;
  final Message? previousMessage;
  final Message? nextMessage;

  @override
  Widget build(BuildContext context) {
    String myUid = context.read<User?>()!.uid;
    Chat chat = context.read<Chat>();

    bool threadTheMessageAbove = previousMessage != null &&
        previousMessage!.author == message.author &&
        message.time.difference(previousMessage!.time).inMinutes < 3;
    bool threadTheMessageBelow = nextMessage != null &&
        nextMessage!.author == message.author &&
        nextMessage!.time.difference(message.time).inMinutes < 3;

    Map<dynamic, dynamic> readReceiptData =
        context.watch<Map<dynamic, dynamic>>();
    ReadReceiptService readReceiptService =
        ReadReceiptService(chat: chat, uid: myUid);

    if (message.type == "TEXT_MESSAGE") {
      return Padding(
        padding: EdgeInsets.only(top: threadTheMessageAbove ? 2 : 30),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: MessageBuble(
              msg: message,
              byMe: message.author == myUid,
              isThereMessageBefore: threadTheMessageAbove,
              isThereMessageAfter: threadTheMessageBelow,
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: chat
                  .getListOfAvatarsFromUids(
                      readReceiptService.getUidsToShowReadReceipt(
                          message.time,
                          nextMessage != null ? nextMessage!.time : null,
                          readReceiptData),
                      excludedUid: myUid)
                  .map((e) => Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: CachedAvatar(
                          url: e,
                          radius: 10,
                        ),
                  ))
                  .toList())
        ]),
      );
    }

    return Container();
  }
}
