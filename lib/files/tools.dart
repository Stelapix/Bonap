import 'package:flutter/material.dart';

import 'package:bonap/files/widgets/theme.dart';
import 'package:provider/provider.dart';

class Constant {
  static String version = "0.1"; //Version de Bonap
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
  static Color colorIconLogin = Color(0xFFFB415B);
  static bool blackTheme = true;

  Color getEnabledColorBorder(BuildContext context) {
    return Colors.grey;
  }

  Color getFocusedColorBorder(BuildContext context) {
    return blackTheme ? Colors.white : Colors.black;
  }


}
