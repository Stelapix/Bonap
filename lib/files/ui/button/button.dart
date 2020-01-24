import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  Button({Key key, this.buttonName, this.icon, this.onPressed})
      : super(key: key);
  final buttonName;
  final icon;
  final onPressed;

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
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
                      onPressed: () async => widget.onPressed),
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
}
