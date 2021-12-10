import 'package:dankon/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Authenticated'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(child: Text("Sign out"), onPressed: () {
          context.read<AuthenticationService>().signOut();
        },),
      ),
    );
  }
}
