import 'dart:async';

import 'package:bonap/files/data/dataStorage.dart';
import 'package:bonap/files/login/connectedWays.dart';
import 'package:bonap/files/login/mainMenu.dart';
import 'package:bonap/files/tools.dart';
import 'package:bonap/files/ui/button/button.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

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
              color: Color(0xFFFB415B),
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
              color: Color(0xFFFB415B),
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
      enableInteractiveSelection: true,
      toolbarOptions: ToolbarOptions(
        selectAll: false,
        cut: false,
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
        fontSize: 20.0,
      ),
      decoration: InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: OwnColor().getEnabledColorBorder(context))),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: OwnColor().getFocusedColorBorder(context))),
        contentPadding: const EdgeInsets.only(top: 12),
        hintText:
            input == "Mot de passe" ? "********" : "stelapix.bonap@gmail.com",
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        prefixIcon: input == "Adresse Email"
            ? Icon(Icons.email, color: OwnColor.colorIconLogin)
            : Icon(Icons.lock, color: OwnColor.colorIconLogin),
        suffixIcon: input == "Mot de passe"
            ? IconButton(
                onPressed: toggleVisibility,
                icon: isHidden
                    ? Icon(Icons.visibility_off, color: OwnColor.colorIconLogin)
                    : Icon(Icons.visibility, color: OwnColor.colorIconLogin),
              )
            : null,
      ),
      obscureText: input == "Mot de passe"
          ? isHidden
          : input == "Adresse Email" ? false : isHidden,
      controller:
          input == "Adresse Email" ? emailController : passwordController,
    );
  }

  void whichButton(ButtonType buttonType, BuildContext context) async {
    if (validateAndSave() == 0) {
      if (ButtonType.Connecter == buttonType) {
        int res = await ConnectedWays().signInWithEmail(
            emailController.text, passwordController.text, context);
        if (res == 0) {
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
