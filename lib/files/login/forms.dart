import 'dart:async';

import 'package:bonap/files/data/dataStorage.dart';
import 'package:bonap/files/drawerItems/menu.dart';
import 'package:bonap/files/login/connectedWays.dart';
import 'package:bonap/files/login/mainMenu.dart';
import 'package:bonap/files/login/signIn.dart';
import 'package:bonap/files/ui/button/button.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:bonap/files/constant.dart';

class Forms extends StatefulWidget {
  @override
  FormsState createState() => FormsState();
}

class FormsState extends State<Forms> {
  static TextEditingController emailController;
  static TextEditingController passwordController;

  // Initialisation des messages d'erreurs
  String errorMessage = '';
  String successMessage = '';

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");
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
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          formSignIn("Adresse Email"),
          SizedBox(height: 20.0),
          Text(
            "Mot de passe",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          formSignIn("Mot de passe"),
          SizedBox(height: 15.0),
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

  //Vérifier qu'une fois le formulaire bien remplit, l'utilisateur existe dans la bdd
  int validateAndSave() {
    final form = KeyForm.formKey.currentState;
    return form.validate() ? 0 : 1;
  }

  //AlertDialogue qui relance la page Login
  Future<bool> alertDialog(String texte, BuildContext context) {
    vibration();
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                texte,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.left,
              ),
              backgroundColor: Colors.white.withOpacity(0.9),
            ));
  }

  //Les 2 champs de saisies pour l'adresse mail et le mot de passe de SignIn
  Widget formSignIn(String input) {
    return TextFormField(
      enableInteractiveSelection: false,
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
      // enabled: Anim.isLoading ? false : true,
      cursorColor: Colors.black,
      style: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
      ),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(205, 225, 0, 1))),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: Color.fromRGBO(0, 191, 255, 1),
        )),
        contentPadding: const EdgeInsets.only(top: 15),
        hintText: input == "Mot de passe" ? "********" : "",
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
        prefixIcon:
            input == "Adresse Email" ? Icon(Icons.email) : Icon(Icons.lock),
        suffixIcon: input == "Mot de passe"
            ? IconButton(
                onPressed: toggleVisibility,
                icon: isHidden
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              )
            : null,
      ),
      obscureText: input == "Mot de passe"
          ? isHidden
          : input == "Adresse Email" ? false : isHidden,
      controller: input == "Adresse Email"
          ? emailController
          : passwordController,
    );
  }

  void whichButton(ButtonType buttonType, BuildContext context) async {
    if (validateAndSave() == 0) {
      if (ButtonType.Connecter == buttonType) {
        print("C'est bien parti");
        int res = await ConnectedWays().signInWithEmail(
            emailController.text,
            passwordController.text,
            context);
        print("ça chauffe");
        if (res == 0) {
          print("presssque");
          Timer(Duration(seconds: 0), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) {
                  Anim.isLoading = false;
                  KeyForm().newKey();
                  DataStorage.loadIngredients();
                  return MainMenu();
                },
              ),
            );
          });
        } else if (res == 1) {
          await alertDialog("Veuillez d'abord vérifier votre e-mail.", context);
          print("email not verified");
        } else if (res == 2) {
          await alertDialog(
              "Vos identifiants sont incorrects.\nMerci de réessayer.",
              context);
          print("wrong details");
        } else {
          print("error");
        }
      } else
        print("button problem");
    } else
      print("form problem");
    // KeyForm.emailController.text = "";
    // KeyForm.passwordController.text = "";
    Anim.isLoading = false;
  }
}
