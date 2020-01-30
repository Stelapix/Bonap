import 'package:flutter/material.dart';

class Constant {
  static String version = "0.1"; //Version de Bonap
  static double width;
  static double height;
  getSizeOfCurrentScreen(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }
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
