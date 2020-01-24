import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class Forms {
  //Clé du formulaire
  final formKey = GlobalKey<FormState>();

  //Vérifier qu'une fois le formulaire bien remplit, l'utilisateur existe dans la bdd
  int validateAndSave() {
    final form = formKey.currentState;
    return form.validate() ? 0 : 1;
  }

  //Vibrer en cas d'identifiants incorrects
  void vibration() {
    if (Vibration.hasVibrator() != null &&
        Vibration.hasAmplitudeControl() != null) {
      Vibration.vibrate(duration: 200, amplitude: 20);
    }
  }

  //AlertDialogue qui relance la page Login
  Future<bool> alertDialog(String texte, BuildContext context) {
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
}
