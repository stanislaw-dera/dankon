import 'package:dankon/constants.dart';
import 'package:dankon/services/authentication.dart';
import 'package:dankon/widgets/huge_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity,),
          const Text(
            ":Dankon",
            style: TextStyle(
                fontSize: 48,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("The nicest place to hang out",
              style: TextStyle(fontSize: 16)),
          const SizedBox(
            height: 40,
          ),
          SignInButton(
            Buttons.Google,

            onPressed: () {
              context.read<AuthenticationService>().signInWithGoogle();
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SignInButton(
            Buttons.FacebookNew,
            onPressed: () {
              context.read<AuthenticationService>().signInWithGoogle();
            },
          ),

        ],
      ),
    );
  }
}
