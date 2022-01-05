import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dankon/models/chat.dart';
import 'package:dankon/screens/main/chats/chats.dart';
import 'package:dankon/screens/main/danks/danks.dart';
import 'package:dankon/screens/main/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {

    // get my chats
    final myUid = context.read<User?>()!.uid;
    Stream<List<Chat>> chatsStream = FirebaseFirestore.instance
        .collection("chats")
        .where('allParticipants', arrayContains: myUid)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) {
          Map<String, dynamic> jsonData = doc.data();
          jsonData["id"] = doc.id;
          return Chat.fromJson(jsonData);
        })
        .toList());

    return StreamProvider<List<Chat>?>.value(
      value: chatsStream,
      initialData: null,
      child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                tabs: const [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.chat)),
                  Tab(icon: Icon(Icons.apps_rounded)),
                ],
              ),
              title: const Text(':Dankon'),
            ),
            body: const TabBarView(
              children: [
                DanksPage(),
                ChatsPage(),
                SettingsPage(),
              ],
            ),
        ),
      ),
    );
  }
}