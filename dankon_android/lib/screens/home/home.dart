import 'package:dankon/screens/home/chats.dart';
import 'package:dankon/services/authentication.dart';
import 'package:dankon/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dankon'), actions: [
        IconButton(onPressed: () {
          context.read<AuthenticationService>().signOut();
        }, icon: Icon(Icons.logout))
      ],),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/search');
        },
        child: Icon(Icons.person_add_alt_1),
      ),
      body: Chats(),
    );
  }
}
