import 'package:dankon/models/response.dart';
import 'package:dankon/models/the_user.dart';
import 'package:dankon/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  String? uid() {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser!.uid;
    } else {
      return null;
    }
  }

  Future<void> signOut() async {
    var messaging = FirebaseMessaging.instance;
    messaging.deleteToken();
    await _firebaseAuth.signOut();
  }

  Future<Response> signInWithGoogle() async {
    try {
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

      return Response(type: "success");

    } on FirebaseAuthException catch (e) {
      if(e.code == "user-disabled") {
        return Response(type: "error", content: "Your account has been disabled! ");
      }
      return Response(type: "error", content: "Unknown error");
    }

  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}