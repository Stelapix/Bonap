import 'dart:async';
import 'package:bonap/widgets/data/dataStorage.dart';
import 'package:bonap/widgets/login/connectedWays.dart';
import 'package:bonap/widgets/login/forms.dart';

import 'package:flutter/material.dart';

enum ButtonType { Inscription, Connexion, Inscrire, Connecter }

class OwnButton extends StatefulWidget {
  OwnButton(
      {Key key, this.buttonName, this.icon, this.onPressed, this.buttonType})
      : super(key: key);
  final buttonName;
  final icon;
  final onPressed;
  final buttonType;

  @override
  _OwnButtonState createState() => _OwnButtonState();
}

class _OwnButtonState extends State<OwnButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      borderRadius: BorderRadius.circular(50.0),
      child: Ink(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.white, width: 1.5),
          borderRadius: BorderRadius.circular(50.0),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(205, 225, 0, 1),
            Color.fromRGBO(0, 191, 255, 1),
          ], begin: Alignment.centerRight, end: Alignment.centerLeft),
        ),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Color.fromRGBO(0, 199, 246, 1),
          borderRadius: BorderRadius.circular(50.0),
          onTap: () async => {
            //         if (validateAndSave() == 0) {
            //   int res = await signInWithEmail(
            //       emailController.text, passwordController.text, context);
            //   setState(() {
            //     isLoading = true;
            //   });
            //   if (res == 0) {
            //     Timer(Duration(seconds: 5), () {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(
            //           builder: (context) {
            //             DataStorage.loadIngredients();
            //             return HomePage();
            //           },
            //         ),
            //       );
            //     });
            //   } else if (res == 1) {
            //     vibration();
            //     await alertDialog("Veuillez d'abord vérifier votre e-mail.", context);
            //     emailController.text = "";
            //     passwordController.text = "";
            //   } else if (res == 2) {
            //     vibration();
            //     await alertDialog(
            //         "Vos identifiants sont incorrects.\nMerci de réessayer.", context);
            //     emailController.text = "";
            //     passwordController.text = "";
            //   } else
            //     print("error");
            // }
          },
          child: Container(
            height: size.height / 12,
            width: size.width,
            child: Row(
              children: <Widget>[
                SizedBox(width: size.width / 12),
                Container(
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      color: Colors.white,
                      child: widget.icon,
                      onPressed: () async => whichButton()),
                ),
                SizedBox(width: size.width / 10),
                Center(child: widget.buttonName),
              ],
            ),
          ),
        ),
      ),
    );
  }

  whichButton() async {
    if (widget.buttonType == ButtonType.Connecter &&
        Forms().validateAndSave() == 0) {
      int res = await ConnectedWays().signInWithEmail(
          emailController.text, passwordController.text, context);
      setState(() {
        isLoading = true;
      });
      if (res == 0) {
        Timer(Duration(seconds: 3), () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                DataStorage.loadIngredients();
                return HomePage();
              },
            ),
          );
        });
      } else if (res == 1) {
        // isLoading = false;
        Forms().vibration();
        await Forms()
            .alertDialog("Veuillez d'abord vérifier votre e-mail.", context);
        emailController.text = "";
        passwordController.text = "";
      } else if (res == 2) {
        // isLoading = false;
        Forms().vibration();
        await Forms().alertDialog(
            "Vos identifiants sont incorrects.\nMerci de réessayer.", context);
        emailController.text = "";
        passwordController.text = "";
      } else
        print("error");
    }
  }
}
