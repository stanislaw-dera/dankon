import 'package:dankon/constants.dart';
import 'package:dankon/screens/home/chats.dart';
import 'package:dankon/services/authentication.dart';
import 'package:dankon/services/database.dart';
import 'package:dankon/services/facebook_profile_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final User me = context.read<User>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/search');
        },
        child: Icon(Icons.person_add_alt_1),
      ),
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
                        backgroundColor: kTextColor,
                        backgroundImage: NetworkImage(getAccessUrlIfFacebook(me.photoURL.toString())),
                        radius: 20,
                      ),
                    ),
                    SizedBox(width: 20,),
                    Text('Dankon', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Expanded(child: Chats()),
            ],
          )
      ),
    );
  }
}
