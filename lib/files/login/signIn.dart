import 'dart:async';

import 'package:bonap/files/login/forms.dart';
import 'package:bonap/files/tools.dart';
import 'package:bonap/files/ui/button/button.dart';
import 'package:bonap/files/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key, this.loggout}) : super(key: key);

  final loggout;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //Paramètres Google
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  bool isGoogleSignIn = false;

  //Paramètres Facebook
  final FacebookLogin facebookSignIn = new FacebookLogin();
  bool isFacebookSignIn = false;

  // bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // isLoading = false;
    if (widget.loggout == true) {
      signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: Constant.height,
                child: Column(
                  children: <Widget>[
                    Loader(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Forms(),
                          SizedBox(height: 30),
                          Text(
                            "Mot de passe oublié ?",
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                          SizedBox(height: 30.0),
                          OwnButton(
                            buttonName: Text("Se connecter",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 26.0)),
                            icon: Icon(
                              Icons.reply_all,
                              color: OwnColor.orange,
                            ),
                            buttonType: ButtonType.Connecter,
                          ),
                          SizedBox(height: 30.0),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: Constant.width / 5.1,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.25, color: Colors.white)),
                          ),
                          Text(
                            " OU CONNECTEZ-VOUS AVEC ",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            width: Constant.width / 5.1,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.25, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 100.0),
                            GoogleButton(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Se connecter via Google
  Future<FirebaseUser> _googleSignIn(BuildContext context) async {
    FirebaseUser currentUser;
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // final FirebaseUser user =
      //     (await auth.signInWithCredential(credential)).user;
      // assert(user.displayName != null);
      // assert(!user.isAnonymous);
      // assert(await user.getIdToken() != null);

      // currentUser = await auth.currentUser();
      // assert(user.uid == currentUser.uid);
      // print(currentUser);
      // print("User Name  : ${currentUser.displayName}");
    } catch (e) {
      print(e);
    }
    return currentUser;
  }

  //Se déconnecter de Facebook et Google
  Future<bool> signOut() async {
    // await auth.signOut();
    // await googleSignIn.signOut();
    // await facebookSignIn.logOut();
    print("User Sign Out");
    return true;
  }

//Gérer le retour en arrière sur la page Login
  Future<bool> onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Voulez-vous vraiment quitter l'application ?",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.left,
        ),
        backgroundColor: Colors.white.withOpacity(0.9),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "ANNULER",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                signOut();
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              }),
        ],
      ),
    );
  }
}
