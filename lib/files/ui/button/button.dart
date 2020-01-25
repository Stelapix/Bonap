import 'package:bonap/files/tools.dart';
import 'package:bonap/files/login/forms.dart';
import 'package:flutter/material.dart';

enum ButtonType { Inscription, Connexion, Inscrire, Connecter }

class OwnButton extends StatefulWidget {
  OwnButton(
      {Key key,
      this.buttonName,
      this.icon,
      this.onPressed,
      this.buttonType,
      this.enableLoader})
      : super(key: key);

  final buttonName;
  final icon;
  final onPressed;
  final buttonType;

  final Function enableLoader;

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
          borderRadius: BorderRadius.circular(50.0),
          gradient: LinearGradient(
              colors: [Color(0xFFFB415B), Color(0xFFEE5623)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft),
        ),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Color.fromRGBO(0, 199, 246, 1),
          borderRadius: BorderRadius.circular(50.0),
          onTap: () {},
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
                    onPressed: () => {
                      setState(() {
                        Anim.isLoading = true;
                      }),
                      FormsState().whichButton(widget.buttonType, context),
                    },
                  ),
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
