import 'package:dankon/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign in"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(child: const Text("Sign in with Google"), onPressed: () async {
          context.read<AuthenticationService>().signInWithGoogle();
        },),
      ),
    );
  }
}
