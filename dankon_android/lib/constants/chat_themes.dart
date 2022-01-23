import 'package:dankon/models/chat_theme.dart';
import 'package:flutter/cupertino.dart';

ChatTheme getChatThemeById(String id) {
  List<ChatTheme> filteredList =
      chatThemes.where((chatTheme) => chatTheme.id == id).toList();
  return filteredList.isNotEmpty ? filteredList.first : chatThemes[0];
}

List<ChatTheme> chatThemes = [
  ChatTheme(
      id: "default",
      name: "Default",
      backgroundColor: const Color(0xFFFEFEFE),
      secondaryColor: const Color(0xFFFEFEFE),
      textColor: const Color(0xFF2E2E2E),
      messageTextColor: const Color(0xFF000000),
      messageBackgroundColor: const Color(0xFFEFEFEF),
      myMessageTextColor: const Color(0xFFFEFEFE),
      myMessageBackgroundColor: const Color(0xFFFFBF00),
      buttonsColor: const Color(0xFFFFBF00)),
  ChatTheme(
      id: "night-mountains-blue",
      name: "Night mountains blue",
      backgroundColor: const Color(0xFF05253D),
      secondaryColor: const Color(0xFF083C63),
      textColor: const Color(0xFFFEFEFE),
      messageTextColor: const Color(0xFFFEFEFE),
      messageBackgroundColor: const Color(0xFF083C63),
      myMessageTextColor: const Color(0xFFFEFEFE),
      myMessageBackgroundColor: const Color(0xFF0E6AAF),
      buttonsColor: const Color(0xFF0E6AAF)),
  ChatTheme(
      id: "dark-forest-green",
      name: "Dark forest green",
      backgroundColor: const Color(0xFF032319),
      secondaryColor: const Color(0xFF08563E),
      textColor: const Color(0xFFFEFEFE),
      messageTextColor: const Color(0xFFFEFEFE),
      messageBackgroundColor: const Color(0xFF08563E),
      myMessageTextColor: const Color(0xFFFEFEFE),
      myMessageBackgroundColor: const Color(0xFF0C7C5A),
      buttonsColor: const Color(0xFF0C7C5A))
];
