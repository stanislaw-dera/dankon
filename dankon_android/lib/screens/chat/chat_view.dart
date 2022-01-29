import 'package:dankon/constants/chat_themes.dart';
import 'package:dankon/constants/constants.dart';
import 'package:dankon/models/chat.dart';
import 'package:dankon/models/chat_theme.dart';
import 'package:dankon/screens/chat/paginated_messages_list.dart';
import 'package:dankon/services/database.dart';
import 'package:dankon/widgets/cached_avatar.dart';
import 'package:dankon/widgets/message_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  ChatTheme chatTheme = getChatThemeById("default");

  void changeTheme(String id) {
    setState(() {
      chatTheme = getChatThemeById(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    String myUid = context.read<User?>()!.uid;
    final Chat chat = ModalRoute.of(context)!.settings.arguments as Chat;

    return MultiProvider(
      providers: [
        Provider<ChatTheme>.value(value: chatTheme),
        Provider<Chat>.value(value: chat)
      ],
      child: Scaffold(
          backgroundColor: chatTheme.backgroundColor,
          appBar: buildAppBar(chat, myUid, chatTheme),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0 - smAvatarRadius),
                        child: PaginatedMessagesList(chat: chat,)
                      ),
              ),
              MessageInput(
                chatId: chat.id,
                databaseService: DatabaseService(uid: myUid),
              )
            ],
          )));
  }
}

AppBar buildAppBar(Chat chat, String myUid, ChatTheme chatTheme) {
  return AppBar(
    centerTitle: false,
    titleSpacing: 0,
    backgroundColor: chatTheme.secondaryColor,
    foregroundColor: chatTheme.textColor,
    elevation: 2,
    title: Row(
      children: [
        CachedAvatar(
          url: chat.getChatImageUrl(myUid),
          radius: 15,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(chat.getChatName(myUid)),
      ],
    ),
  );
}

class ChatWelcome extends StatelessWidget {
  final String photoUrl;
  final String title;

  const ChatWelcome({Key? key, required this.photoUrl, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatTheme chatTheme = context.read<ChatTheme>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedAvatar(
          url: photoUrl,
          radius: 30,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 20, color: chatTheme.textColor),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "$title is looking forward to your first message.\nGo on!",
          style: TextStyle(color: chatTheme.textColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
