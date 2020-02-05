import 'dart:async';

import 'package:bonap/files/login/forms.dart';
import 'package:bonap/files/login/mainMenu.dart';
import 'package:bonap/files/tools.dart';
import 'package:bonap/files/ui/button/button.dart';
import 'package:bonap/files/widgets/loader.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    KeyForm().newKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.sync(MainMenuState().backToMainMenu),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: Constant.height + 50,
                child: Column(
                  children: <Widget>[
                    Loader(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Forms(
                            whichForms: "signUpForm",
                          ),
                          SizedBox(height: 30.0),
                          OwnButton(
                            buttonName: "S'inscrire",
                            icon: Icon(
                              Icons.mode_edit,
                              color: OwnColor.orange,
                            ),
                            buttonType: ButtonType.Inscrire,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: Constant.width / 6,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.25, color: Colors.white)),
                          ),
                          Text(
                            " OU INSCRIVEZ-VOUS AVEC ",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            width: Constant.width / 6,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.25, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
}
