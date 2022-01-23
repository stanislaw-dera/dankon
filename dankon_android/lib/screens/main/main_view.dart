import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dankon/constants/constants.dart';
import 'package:dankon/models/chat.dart';
import 'package:dankon/screens/main/chats/chats.dart';
import 'package:dankon/screens/main/danks/danks.dart';
import 'package:dankon/services/facebook_profile_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  int _selectedPage = 0;
  static const List<Widget> _pages = <Widget>[
    DanksPage(),
    ChatsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User me = context.read<User>();
    final myUid = me.uid;
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
            body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/settings');
                            },
                            child: CircleAvatar(
                              backgroundColor: kDarkColor,
                              backgroundImage: NetworkImage(getAccessUrlIfFacebook(me.photoURL.toString())),
                              radius: 20,
                            ),
                          ),
                          const SizedBox(width: 20,),
                          const Text('Dankon', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Expanded(child: _pages.elementAt(_selectedPage)),
                  ],
                )
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: ':Dank',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Chat',
                ),
              ],
              selectedItemColor: kDarkColor,
              currentIndex: _selectedPage,
              onTap: _onItemTapped,
            ),
        ),
      )
    );
  }
}