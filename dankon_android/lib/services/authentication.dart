import 'package:dankon/models/the_user.dart';
import 'package:dankon/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    if(userCredential.additionalUserInfo!.isNewUser == true) {
      TheUser theUser = TheUser(uid: userCredential.user!.uid, name: userCredential.user!.displayName.toString(), urlAvatar: userCredential.user!.photoURL.toString());
      DatabaseService databaseService = DatabaseService(uid: theUser.uid);
      await databaseService.createUser(theUser);
    }
  }

  Future<void> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

    if(userCredential.additionalUserInfo!.isNewUser == true) {
      TheUser theUser = TheUser(uid: userCredential.user!.uid, name: userCredential.user!.displayName.toString(), urlAvatar: userCredential.user!.photoURL.toString());
      DatabaseService databaseService = DatabaseService(uid: theUser.uid);
      await databaseService.createUser(theUser);
    }
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}