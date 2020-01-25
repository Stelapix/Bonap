import 'package:flutter/material.dart';

class Constant {
  static String version = "0.1"; //Version de Bonap
}

class Anim {
  static bool isLoading = false;
}

class KeyForm {
  static var formKey =
      GlobalKey<FormState>(); //Clé pour les formulaires du login
  void newKey() => formKey = new GlobalKey<FormState>();
}
