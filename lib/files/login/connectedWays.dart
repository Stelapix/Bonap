import 'package:firebase_auth/firebase_auth.dart';

class ConnectedWays {
  //Authentification à Firebase
  final FirebaseAuth auth = FirebaseAuth.instance;

  //Se connecter sur Bonap
  Future<int> signInWithEmail(String email, String password, context) async {
    if (email.contains(" ")) {
      email = email.substring(0, email.indexOf(" "));
    }
    try {
      AuthResult result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
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
