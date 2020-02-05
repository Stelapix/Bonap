import 'package:bonap/files/login/mainMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constant {
  static String version = "0.1"; //Version de Bonap
  static double width;
  static double height;
  getSizeOfCurrentScreen(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }
}

class LoginTools {
  static bool loggout = false;
  static bool guestMode = false;
  static final FirebaseAuth auth =
      FirebaseAuth.instance; //Authentification à Firebase
}

class Anim {
  static bool isLoading = true;
}

class KeyForm {
  static var formKey =
      GlobalKey<FormState>(); //Clé pour les formulaires du login
  void newKey() => formKey = new GlobalKey<FormState>();
}

class OwnColor {
  static Color orange = Color(0xFFEE5623);
  static Color orangeDarker = Color(0xFFFB415B);
  static Color yellow = Color.fromRGBO(246, 199, 0, 1);
  static bool blackTheme = true;

  Color getEnabledColorBorder(BuildContext context) {
    return Colors.grey;
  }

  Color getFocusedColorBorder(BuildContext context) {
    return blackTheme ? Colors.white : Colors.black;
  }
}

class FunctionTools {
  Future<bool> onBackPressed(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MainMenu()));
    return null;
  }
}