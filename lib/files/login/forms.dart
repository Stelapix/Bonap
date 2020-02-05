import 'dart:async';

import 'package:bonap/files/data/dataStorage.dart';
import 'package:bonap/files/drawerItems/menu.dart';
import 'package:bonap/files/login/connectedWays.dart';
import 'package:bonap/files/login/mainMenu.dart';
import 'package:bonap/files/tools.dart';
import 'package:bonap/files/ui/button/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class Forms extends StatefulWidget {
  const Forms({Key key, this.whichForms}) : super(key: key);
  final whichForms;

  @override
  FormsState createState() => FormsState();
}

class FormsState extends State<Forms> {
  static TextEditingController emailController;
  static TextEditingController passwordForgotController;
  static TextEditingController passwordController;
  static TextEditingController passwordCheckController;

  @override
  void initState() {
    super.initState();
    KeyForm().newKey();
    emailController = TextEditingController(text: "");
    passwordForgotController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");
    passwordCheckController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: KeyForm.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Adresse Email",
            style: TextStyle(
              color: Color(0xFFEE5623),
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          SizedBox(height: 10),
          widget.whichForms == "signUpForm"
              ? formSignUp("Adresse Email")
              : formSignIn("Adresse Email"),
          SizedBox(height: 20.0),
          Text(
            "Mot de passe",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
              color: Color(0xFFEE5623),
            ),
          ),
          SizedBox(height: 10),
          widget.whichForms == "signUpForm"
              ? formSignUp("Mot de passe")
              : formSignIn("Mot de passe"),
          widget.whichForms == "signUpForm"
              ? SizedBox(height: 20.0)
              : Container(),
          widget.whichForms == "signUpForm"
              ? Text(
                  "Confirmer le mot de passe",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Color(0xFFEE5623),
                  ),
                )
              : Container(),
          widget.whichForms == "signUpForm"
              ? SizedBox(height: 10.0)
              : Container(),
          widget.whichForms == "signUpForm"
              ? formSignUp("Confirmez le mot de passe")
              : Container(),
        ],
      ),
    );
  }

  //Pour cacher/afficher le mot de passe
  bool isHidden = true;

  void toggleVisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  //Vibrer en cas d'identifiants incorrects
  void vibration() {
    if (Vibration.hasVibrator() != null &&
        Vibration.hasAmplitudeControl() != null) {
      Vibration.vibrate(duration: 200, amplitude: 20);
    }
  }

  bool validateFormLogin() {
    final form = KeyForm.formKey.currentState;
    return form.validate();
  }

  bool validateFormPasswordReset() {
    final form = KeyForm.passwordResetKey.currentState;
    return form.validate();
  }

  Future<void> resetPassword(String mail) async {
    await LoginTools.auth.sendPasswordResetEmail(email: mail);
  }

  Future<bool> alertPasswordReset(
      String title, String text, BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
              title: Text(title,
                  style: TextStyle(color: OwnColor.orange, fontSize: 22),
                  textAlign: TextAlign.left),
              content: Container(
                height: Constant.height / 3.2,
                child: Form(
                  key: KeyForm.passwordResetKey,
                  child: Column(
                    children: <Widget>[
                      Divider(color: Colors.white),
                      SizedBox(height: 20),
                      Text(text,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 17)),
                      SizedBox(height: 10),
                      formPasswordForgot("PasswordReset"),
                      SizedBox(height: 20),
                      FlatButton(
                          color: OwnColor.orange,
                          child: Text('Réinitialiser'),
                          onPressed: () {
                            if (validateFormPasswordReset()) {
                              if (passwordForgotController.text.contains(" ")) {
                                passwordForgotController.text =
                                    passwordForgotController.text.substring(
                                        0,
                                        passwordForgotController.text
                                            .indexOf(" "));
                              }
                              resetPassword(passwordForgotController.text);
                              Navigator.of(context).pop();
                              alertDialog(
                                  "Ne l'oubliez plus !",
                                  "Un email de réinitialisation va vous être envoyé",
                                  context);
                            }
                          }),
                    ],
                  ),
                ),
              ),
              backgroundColor: OwnColor.darkBackground,
            ));
  }

  Future<bool> alertDialog(String title, String text, BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                title,
                style: TextStyle(
                  color: OwnColor.orange,
                ),
                textAlign: TextAlign.left,
              ),
              content: Text(text, style: TextStyle(color: Colors.white)),
              backgroundColor: OwnColor.darkBackground,
            ));
  }

  //Les 2 champs de saisies pour l'adresse mail et le mot de passe de SignUn
  Widget formSignUp(String input) {
    return TextFormField(
      enableInteractiveSelection: true,
      toolbarOptions: ToolbarOptions(
        selectAll: false,
        cut: true,
        copy: true,
        paste: true,
      ),
      validator: (value) {
        if (value.isEmpty && input == 'Adresse Email') {
          print("Email required");
          return 'Vous devez saisir une adresse email.';
        } else if (value.isEmpty && input == 'Mot de passe') {
          print("Password required");
          return 'Vous devez saisir un mot de passe.';
        } else if (value.isEmpty && input == 'Confirmer le mot de passe') {
          print("PasswordCheck required");
          return 'Vous devez saisir le\nmot de passe de confirmation.';
        } else if (input == 'Adresse Email' &&
            !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value)) {
          return "Format d'adresse email invalide.";
        } else if (input == 'Mot de passe' && value.length < 6) {
          return "Votre mot de passe doit comporter au moins 6 caractères.";
        } else if (input == "Confirmez le mot de passe" &&
            passwordController.text != passwordCheckController.text) {
          print("Passwords are not the same");
          return 'Les mots de passes sont différents.';
        } else
          return null;
      },
      style: TextStyle(
        fontSize: 18.0,
      ),
      decoration: InputDecoration(
        filled: true,
        enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: OwnColor().getEnabledColorBorder(context))),
        focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: OwnColor().getFocusedColorBorder(context))),
        contentPadding: const EdgeInsets.only(top: 12),
        hintText: input == "Mot de passe"
            ? "********"
            : input == "Adresse Email"
                ? "stelapix.bonap@gmail.com"
                : "xXx_BonapPGM_xXx",
        hintStyle: TextStyle(
          fontSize: 20.0,
        ),
        prefixIcon: input == "Adresse Email"
            ? Icon(Icons.email, color: Colors.white)
            : input == "Mot de passe"
                ? Icon(Icons.lock, color: Colors.white)
                : Icon(Icons.check, color: Colors.white),
        suffixIcon: input == "Mot de passe"
            ? IconButton(
                onPressed: toggleVisibility,
                icon: isHidden
                    ? Icon(Icons.visibility_off, color: Colors.white)
                    : Icon(Icons.visibility, color: OwnColor.orange),
              )
            : null,
      ),
      obscureText: input == "Mot de passe"
          ? isHidden
          : input == "Adresse Email" ? false : isHidden,
      controller: input == "Adresse Email"
          ? emailController
          : input == "Mot de passe"
              ? passwordController
              : passwordCheckController,
    );
  }

  //Les 3 champs de saisies pour l'adresse mail, le mot de passe et la confirmation du mot de passe de SignIn
  Widget formSignIn(String input) {
    return TextFormField(
      enableInteractiveSelection: true,
      toolbarOptions: ToolbarOptions(
        selectAll: false,
        cut: true,
        copy: true,
        paste: true,
      ),
      validator: (value) {
        if (value.isEmpty && input == 'Adresse Email') {
          print("Email required");
          return 'Vous devez saisir une adresse email.';
        } else if (value.isEmpty && input == 'Mot de passe') {
          print("Password required");
          return 'Vous devez saisir un mot de passe.';
        } else if (input == 'Adresse Email' &&
            !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value)) {
          return "Format d'adresse email invalide.";
        } else if (input == 'Mot de passe' && value.length < 6) {
          return "Votre mot de passe doit comporter au moins 6 caractères.";
        } else
          return null;
      },
      style: TextStyle(
        fontSize: 18.0,
      ),
      decoration: InputDecoration(
        filled: true,
        enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: OwnColor().getEnabledColorBorder(context))),
        focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: OwnColor().getFocusedColorBorder(context))),
        contentPadding: const EdgeInsets.only(top: 12),
        hintText:
            input == "Adresse Email" ? "stelapix.bonap@gmail.com" : "********",
        hintStyle: TextStyle(
          fontSize: 20.0,
        ),
        prefixIcon: input == "Adresse Email"
            ? Icon(Icons.email, color: Colors.white)
            : Icon(Icons.lock, color: Colors.white),
        suffixIcon: input == "Mot de passe"
            ? IconButton(
                onPressed: toggleVisibility,
                icon: isHidden
                    ? Icon(Icons.visibility_off, color: Colors.white)
                    : Icon(Icons.visibility, color: OwnColor.orange),
              )
            : null,
      ),
      obscureText: input == "Mot de passe" ? isHidden : false,
      controller:
          input == "Adresse Email" ? emailController : passwordController,
    );
  }

  Widget formPasswordForgot(String input) {
    return TextFormField(
        enableInteractiveSelection: true,
        toolbarOptions: ToolbarOptions(
          selectAll: false,
          cut: true,
          copy: true,
          paste: true,
        ),
        validator: (value) {
          if (value.isEmpty && input == "PasswordReset") {
            print("Email required");
            return 'Vous devez saisir une adresse email.';
          } else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return "Format d'adresse email invalide.";
          } else
            return null;
        },
        style: TextStyle(
          fontSize: 18.0,
        ),
        decoration: InputDecoration(
          filled: true,
          enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: OwnColor().getEnabledColorBorder(context))),
          focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: OwnColor().getFocusedColorBorder(context))),
          hintText: "stelapix.bonap@gmail.com",
          hintStyle: TextStyle(
            fontSize: 20.0,
          ),
        ),
        controller: passwordForgotController);
  }

  void whichButton(ButtonType buttonType, BuildContext context) async {
    if (validateFormLogin()) {
      if (buttonType == ButtonType.Connecter) {
        int res = await BonapWay().signInWithEmail(
            emailController.text, passwordController.text, context);
        if (res == 0) {
          //TODO Pour une future animation ?
          Timer(Duration(seconds: 0), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) {
                  KeyForm().newKey();
                  DataStorage.loadIngredients();
                  return Menu();
                },
              ),
            );
          });
        } else if (res == 1) {
          await alertDialog(
              "Patience...", "Veuillez d'abord vérifier votre e-mail.", context);
          print("email not verified");
        } else if (res == 2) {
          await alertDialog(
              "Oups !",
              "Vos identifiants sont incorrects.\nMerci de réessayer.",
              context);
          emailController.text = "";
          passwordController.text = "";
          print("wrong details");
        } else {
          print("error");
        }
      } else if (buttonType == ButtonType.Inscrire) {
        if (emailController.text.contains(" ")) {
          emailController.text = emailController.text
              .substring(0, emailController.text.indexOf(" "));
        }
        try {
          FirebaseUser user = (await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text))
              .user;
          Timer(Duration(seconds: 0), () async {
            user.sendEmailVerification();
            print("Sign Up");
            KeyForm().newKey();
            await alertDialog(
                "Compte a été créé.",
                "Veuillez vérifier l'adresse e-mail : " +
                    user.email +
                    "\n\nCliquez sur le lien fourni dans l'e-mail que vous avez reçu.",
                context);
            Future.sync(MainMenuState().backToSignIn);
          });
        } catch (e) {
          print(e.message);
          await alertPasswordReset(
              "Adresse déjà utilisée.\nMerci de réessayer.", "", context);
          emailController.text = "";
          passwordController.text = "";
          passwordCheckController.text = "";
        }
      }
    } else
      print("form problem");
  }
}
