import 'package:dankon/constants/constants.dart';
import 'package:dankon/models/response.dart';
import 'package:dankon/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(image: AssetImage("assets/rocket.png")),
                const SizedBox(
                  width: double.infinity,
                ),
                const Text(
                  "Hello!",
                  style: TextStyle(
                      fontSize: 48,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold),
                ),
                const Text("Welcome to :Dankon",
                    style: TextStyle(fontSize: 16)),
                const SizedBox(
                  height: 20,
                ),
                SignInButton(
                  Buttons.Google,
                  onPressed: () async {
                    toggleLoading();
                    Response signInResponse = await context
                        .read<AuthenticationService>()
                        .signInWithGoogle();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(signInResponse.type == "error"
                            ? signInResponse.content!
                            : "Signed in!")));
                    toggleLoading();
                  },
                ),
              ],
            ),
    );
  }
}
