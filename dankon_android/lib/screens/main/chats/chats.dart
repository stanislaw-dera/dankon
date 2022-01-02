import 'package:flutter/material.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text("Comming soon", style: TextStyle(fontSize: 28),),
        SizedBox(height: 5,),
        Text("We are going to introduce chat in future.")
      ],
    );
  }
}
