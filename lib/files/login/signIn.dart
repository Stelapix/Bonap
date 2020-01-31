import 'dart:async';

import 'package:bonap/files/login/forms.dart';
import 'package:bonap/files/login/mainMenu.dart';
import 'package:bonap/files/tools.dart';
import 'package:bonap/files/ui/button/button.dart';
import 'package:bonap/files/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
                            buttonName: "Se connecter",
                            icon: Icon(
                              Icons.reply_all,
                              color: OwnColor.orangeDarker,
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
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              }),
        ],
      ),
    );
  }
}
