import 'package:dankon/screens/main/chats/chats.dart';
import 'package:dankon/screens/main/danks/danks.dart';
import 'package:dankon/screens/main/settings/settings.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
    );
  }
}