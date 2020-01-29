import 'dart:async';

import 'package:bonap/files/drawerItems/menu.dart';
import 'package:bonap/files/login/mainMenu.dart';
import 'package:bonap/files/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final Function functionValidateAndSave;
  final Function functionSignInWithEmail;
  final Function functionVibration;
  final Function functionAlertDialog;

  SignUpPage(this.functionValidateAndSave, this.functionSignInWithEmail,
      this.functionVibration, this.functionAlertDialog);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //Clé du formulaire
  final formKey = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;

  //Les variables contenant l'Email et le mot de passe
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController passwordCheckController;

  //Pour cacher/afficher le mot de passe
  bool isHidden = true;

  bool isLoading = false;

  void toggleVisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;
    emailController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");
    passwordCheckController = TextEditingController(text: "");
  }

  Future<bool> onBackPressed() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MainMenu()));
    return null;
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/splash/splash2.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: <Widget>[
                      Loader(),
                      SizedBox(height: 30.0),
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 50.0),
                            inputText("Adresse Email"),
                            SizedBox(height: 10.0),
                            inputText("Mot de passe"),
                            SizedBox(height: 10.0),
                            inputText("Confirmer le mot de passe"),
                            SizedBox(height: 15.0),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      buttonSignUp(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Vérifier qu'une fois le formulaire bien remplit, l'utilisateur existe dans la bdd
  int validateAndSave() {
    final form = formKey.currentState;
    if (form.validate())
      return 0;
    else
      return 1;
  }

  //Les 2 champs de saisies pour l'adresse Mail et le mot de passe
  Widget inputText(String hintText) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty && hintText == 'Adresse Email') {
          print("Email required");
          return 'Vous devez saisir une adresse email.';
        } else if (value.isEmpty && hintText == 'Mot de passe') {
          print("Password required");
          return 'Vous devez saisir un mot de passe.';
        } else if (value.isEmpty && hintText == 'Confirmer le mot de passe') {
          print("PasswordCheck required");
          return 'Vous devez saisir le\nmot de passe de confirmation.';
        } else if (hintText == 'Adresse Email' &&
            !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value)) {
          return "Format d'adresse email invalide.";
        } else if (hintText == 'Mot de passe' && value.length < 6) {
          return "Votre mot de passe doit comporter\nau moins 6 caractères.";
        } else if (passwordController.text != passwordCheckController.text) {
          print("Passwords are not the same");
          return 'Les mots de passes sont différents.';
        } else {
          return null;
        }
      },
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        focusColor: Colors.orange,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: Color(0xFFEE5623), width: 1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: Color(0xFFEE5623), width: 1.5)),
        prefixIcon: hintText == "Adresse Email"
            ? Icon(Icons.email, color: Colors.black)
            : hintText == "Mot de passe"
                ? Icon(Icons.lock, color: Colors.black)
                : Icon(Icons.check, color: Colors.black),
        suffixIcon: hintText == "Mot de passe"
            ? IconButton(
                color: Colors.black,
                onPressed: toggleVisibility,
                icon: isHidden
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              )
            : null,
      ),
      obscureText: hintText == "Mot de passe"
          ? isHidden
          : hintText == "Adresse Email" ? false : isHidden,
      controller: hintText == "Adresse Email"
          ? emailController
          : hintText == "Mot de passe"
              ? passwordController
              : passwordCheckController,
    );
  }

  //Bouton 'Inscrivez-vous'
  Widget buttonSignUp() {
    return Material(
      animationDuration: Duration(seconds: 10),
      borderRadius: BorderRadius.circular(50.0),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          gradient: LinearGradient(
              colors: [Color(0xFFFB415B), Color(0xFFEE5623)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(50.0),
          onTap: () async {
            if (validateAndSave() == 0) {
              if (emailController.text.contains(" ")) {
                emailController.text = emailController.text
                    .substring(0, emailController.text.indexOf(" "));
              }
              try {
                setState(() {
                  isLoading = true;
                });
                FirebaseUser user = (await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text))
                    .user;
                Timer(Duration(seconds: 0), () async {
                  setState(() {
                    isLoading = false;
                  });
                  user.sendEmailVerification();
                  print("Sign Up");
                  await widget.functionAlertDialog(
                      "Votre compte a été créé.\n\nVeuillez vérifier l'adresse e-mail : " +
                          user.email +
                          "\n\nCliquez sur le lien fourni dans l'e-mail que vous avez reçu.",
                      context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Menu()));
                });
              } catch (e) {
                print(e.message);
                await widget.functionAlertDialog(
                    "Adresse déjà utilisée.\nMerci de réessayer.", context);
                emailController.text = "";
                passwordController.text = "";
                passwordCheckController.text = "";
              }
            }
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 12,
            child: Center(
              child: Text(
                "S'inscrire",
                style: TextStyle(color: Colors.white, fontSize: 26.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
