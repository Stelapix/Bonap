import 'dart:async';

import 'package:bonap/files/constant.dart';
import 'package:bonap/files/login/forms.dart';
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
                height: MediaQuery.of(context).size.height,
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   image: DecorationImage(
                //     colorFilter: new ColorFilter.mode(
                //         Colors.black.withOpacity(0.2), BlendMode.dstATop),
                //     image: AssetImage('assets/splash/splash2.jpg'),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                child: Column(
                  children: <Widget>[
                    Loader(),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: <Widget>[
                            Forms(),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 117.0),
                                  Text(
                                    "Mot de passe oublié ?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.0),
                            OwnButton(
                              buttonName: Text("Connexion",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 26.0)),
                              icon: Icon(
                                Icons.arrow_right,
                                color: Color(0xFFFB415B),
                              ),
                              buttonType: ButtonType.Connecter,
                              // enableLoader: () => enableLoader(),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[],
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _signInGoogleButton(),
                                SizedBox(width: 5.0),
                                _signInFacebookButton(),
                              ],
                            ),
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

  // void enableLoader() {
  //   setState(() {
  //     isLoading = !isLoading;
  //   });
  // }

  //Bouton 'Connectez-vous'
  Widget buttonConnexion() {
    return Material(
      animationDuration: const Duration(seconds: 10),
      borderRadius: BorderRadius.circular(20.0),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(colors: <Color>[
            Color.fromRGBO(205, 225, 0, 1),
            Color.fromRGBO(0, 191, 255, 1),
          ], begin: Alignment.centerRight, end: Alignment.centerLeft),
        ),
        child: InkWell(
          onTap: () async {},
          child: Container(
            height: 50.0,
            child: new Center(
              child: new Text(
                'Connexion',
                style: new TextStyle(fontSize: 22.0, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Bouton connexion de Google
  Widget _signInGoogleButton() {
    return DecoratedBox(
      decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          color: Colors.white),
      child: OutlineButton(
        onPressed: () {
          // _googleSignIn(context).then((user) {
          //   if (user != null) {

          //     print('Logged in successfully.');
          // if (this.mounted) {
          //   setState(() {
          //     isGoogleSignIn = true;
          //     successMessage = 'Logged in successfully';
          //     DataStorage.loadIngredients();
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (BuildContext context) => HomePage()));
          //   });
          // }
          //   } else
          //     print('Login Canceled');
          // });
        },
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0),
        ),
        highlightElevation: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  'Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //Bouton connexion de Facebook
  Widget _signInFacebookButton() {
    return DecoratedBox(
      decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          color: Color(0xff3b5998)),
      child: OutlineButton(
        onPressed: () {
          // _facebookSignIn(context).then((user) {
          //   if (user != null) {
          //     print('Logged in successfully.');
          //     DataStorage.loadIngredients();
          //     if (this.mounted)
          //       setState(() {
          //         isFacebookSignIn = true;
          //         successMessage = 'Logged in successfully';
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (BuildContext context) => HomePage()));
          //       });
          //   } else
          //     print('Login Canceled');
          // });
        },
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0),
        ),
        splashColor: Colors.white.withOpacity(0),
        highlightElevation: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/facebook_logo.png"), height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Text(
                  'Facebook',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //Se connecter via Facebook
  Future<FirebaseUser> _facebookSignIn(BuildContext context) async {
    FirebaseUser currentUser;
    try {
      final FacebookLoginResult result =
          await facebookSignIn.logInWithReadPermissions(['email']);

      final FacebookAccessToken accessToken = result.accessToken; //Erreur

      final AuthCredential credential =
          FacebookAuthProvider.getCredential(accessToken: accessToken.token);

      // final FirebaseUser user =
      //     (await auth.signInWithCredential(credential)).user;
      // assert(user.displayName != null);
      // assert(!user.isAnonymous);
      // assert(await user.getIdToken() != null);

      // currentUser = await auth.currentUser();
      // assert(user.uid == currentUser.uid);
      // print(currentUser);
      print("User Name  : ${currentUser.displayName}");
    } catch (e) {
      print(e);
    }
    return currentUser;
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
