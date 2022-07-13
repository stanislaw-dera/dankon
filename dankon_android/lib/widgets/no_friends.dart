import 'package:dankon/constants/constants.dart';
import 'package:flutter/material.dart';

class NoFriends extends StatelessWidget {
  const NoFriends({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Image(image: AssetImage("assets/add_friends.png"), width: 200,),
          const SizedBox(
            height: 20,
            width: double.infinity,
          ),
          const Text(
            "Now add friends",
            style: TextStyle(
                fontSize: 24,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2,),
          const Text("Dank, chat and play", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 10,),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamed("/search");
          }, child: const Text("Add friends", style: TextStyle(color: kDarkColor),))
        ]);
  }
}
