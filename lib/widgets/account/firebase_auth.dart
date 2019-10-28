import 'package:bonap/homePage.dart';
import 'package:bonap/main.dart';
import 'package:bonap/widgets/account/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<bool> signInWithEmail(String email, String password, context) async {
  if (email.contains(" ")) {
    email = email.substring(0, email.indexOf(" "));
  }
  try {
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    if (user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return HomePage();
          },
        ),
      );
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

void signOutGoogle(context) async {
  await googleSignIn.signOut();
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) {
        return LoginPage();
      },
    ),
  );
  print("---------------------> User Sign Out");
}

Future navigateToSubPage(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
}

Future navigateToSubPage2(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
}

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return '---------------------> signInWithGoogle succeeded: $user';
}
