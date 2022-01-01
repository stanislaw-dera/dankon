import 'package:dankon/screens/home/chats.dart';
import 'package:dankon/services/facebook_profile_images.dart';
import 'package:dankon/widgets/cached_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        child: const Icon(Icons.person_add_alt_1),
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
                      child: CachedAvatar(url: getAccessUrlIfFacebook(me.photoURL.toString()), radius: 20,)
                    ),
                    const SizedBox(width: 20,),
                    const Text('Dankon', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const Expanded(child: Chats()),
            ],
          )
      ),
    );
  }
}
