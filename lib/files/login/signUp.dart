import 'dart:async';

import 'package:bonap/files/drawerItems/menu.dart';
import 'package:bonap/files/login/forms.dart';
import 'package:bonap/files/login/mainMenu.dart';
import 'package:bonap/files/tools.dart';
import 'package:bonap/files/ui/button/button.dart';
import 'package:bonap/files/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.sync(MainMenuState().backToMainMenu),
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
                          Forms(
                            whichForms: "signUpForm",
                          ),
                          SizedBox(height: 30.0),
                          OwnButton(
                            buttonName: "S'inscrire",
                            icon: Icon(
                              Icons.mode_edit,
                              color: OwnColor.orangeDarker,
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
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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

  // //Bouton 'Inscrivez-vous'
  // Widget buttonSignUp() {
  //   return Material(
  //     animationDuration: Duration(seconds: 10),
  //     borderRadius: BorderRadius.circular(50.0),
  //     child: Ink(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(50.0),
  //         gradient: LinearGradient(
  //             colors: [Color(0xFFFB415B), Color(0xFFEE5623)],
  //             begin: Alignment.centerRight,
  //             end: Alignment.centerLeft),
  //       ),
  //       child: InkWell(
  //         borderRadius: BorderRadius.circular(50.0),
  //         onTap: () async {
  //           if (validateAndSave() == 0) {
  //             if (emailController.text.contains(" ")) {
  //               emailController.text = emailController.text
  //                   .substring(0, emailController.text.indexOf(" "));
  //             }
  //             try {
  //               setState(() {
  //                 isLoading = true;
  //               });
  //               FirebaseUser user = (await FirebaseAuth.instance
  //                       .createUserWithEmailAndPassword(
  //                           email: emailController.text,
  //                           password: passwordController.text))
  //                   .user;
  //               Timer(Duration(seconds: 0), () async {
  //                 setState(() {
  //                   isLoading = false;
  //                 });
  //                 user.sendEmailVerification();
  //                 print("Sign Up");
  //                 await widget.functionAlertDialog(
  //                     "Votre compte a été créé.\n\nVeuillez vérifier l'adresse e-mail : " +
  //                         user.email +
  //                         "\n\nCliquez sur le lien fourni dans l'e-mail que vous avez reçu.",
  //                     context);
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (BuildContext context) => Menu()));
  //               });
  //             } catch (e) {
  //               print(e.message);
  //               await widget.functionAlertDialog(
  //                   "Adresse déjà utilisée.\nMerci de réessayer.", context);
  //               emailController.text = "";
  //               passwordController.text = "";
  //               passwordCheckController.text = "";
  //             }
  //           }
  //         },
  //         child: Container(
  //           height: MediaQuery.of(context).size.height / 12,
  //           child: Center(
  //             child: Text(
  //               "S'inscrire",
  //               style: TextStyle(color: Colors.white, fontSize: 26.0),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  // );
  // }
}
