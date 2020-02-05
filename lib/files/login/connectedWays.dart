import 'package:bonap/files/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class BonapWay {
  //Se connecter sur Bonap
  Future<int> signInWithEmail(String email, String password, context) async {
    if (email.contains(" ")) email = email.substring(0, email.indexOf(" "));
    try {
      AuthResult result = await LoginTools.auth
          .signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      if (user != null) {
        if (user.isEmailVerified) {
          print(user);
          return 0;
        } else {
          print("email is not verified");
          return 1;
        }
      } else {
        print("user is null");
        return -1;
      }
    } catch (e) {
      print(e);
      return 2;
    }
  }
}

class GoogleWay {
  //Paramètres Google
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //Se connecter via Google
  Future<FirebaseUser> signInWithGoogle(BuildContext context) async {
    FirebaseUser currentUser;
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user =
          (await LoginTools.auth.signInWithCredential(credential)).user;
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      currentUser = await LoginTools.auth.currentUser();
      assert(user.uid == currentUser.uid);
      print(currentUser);
      print("User Name  : ${currentUser.displayName}");
    } catch (e) {
      print("error");
      print(e);
    }
    return currentUser;
  }
}
