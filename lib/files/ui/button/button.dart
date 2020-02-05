import 'package:bonap/files/drawerItems/menu.dart';
import 'package:bonap/files/login/connectedWays.dart';
import 'package:bonap/files/login/mainMenu.dart';
import 'package:bonap/files/tools.dart';
import 'package:bonap/files/login/forms.dart';
import 'package:flutter/material.dart';

enum ButtonType { Inscription, Connexion, Inscrire, Connecter, Guest }

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
  PageController controller =
      new PageController(initialPage: 1, viewportFraction: 1.0);

  void result() {
    if (widget.buttonType == ButtonType.Connecter ||
        widget.buttonType == ButtonType.Inscrire)
      FormsState().whichButton(widget.buttonType, context);
    else if (widget.buttonType == ButtonType.Connexion)
      MainMenuState().goto(0);
    else if (widget.buttonType == ButtonType.Inscription)
      MainMenuState().goto(2);
    else if (widget.buttonType == ButtonType.Guest) {
      LoginTools.guestMode = true;
      print("Guest Mode activated");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Menu()));
    }
  }

  Widget whereIsFlatButton() {
    if (widget.buttonType != ButtonType.Inscription &&
        widget.buttonType != ButtonType.Inscrire)
      return Row(
        children: <Widget>[
          SizedBox(width: Constant.width / 30),
          Container(
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              color: Colors.white,
              child: widget.icon,
              onPressed: () => result(),
            ),
          ),
          SizedBox(width: Constant.width / 10),
          Center(
            child: Text(widget.buttonName,
                style: TextStyle(color: Colors.white, fontSize: 26.0)),
          ),
        ],
      );
    else
      return Row(
        children: <Widget>[
          SizedBox(width: Constant.width / 12),
          Expanded(
            child: Center(
              child: Text(
                widget.buttonName,
                style: TextStyle(color: Colors.white, fontSize: 26.0),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 11),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              color: Colors.white,
              child: widget.icon,
              onPressed: () => result(),
            ),
          ),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(50.0),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          gradient: LinearGradient(
              colors: widget.buttonType == ButtonType.Connecter ||
                      widget.buttonType == ButtonType.Inscription
                  ? [OwnColor.yellow, OwnColor.orangeDarker]
                  : widget.buttonType != ButtonType.Guest
                      ? [OwnColor.orangeDarker, OwnColor.yellow]
                      : [Colors.green, Colors.blue],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft),
        ),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: widget.buttonType == ButtonType.Guest ? OwnColor.blueSplash : OwnColor.orangeSplash,
          borderRadius: BorderRadius.circular(50.0),
          onTap: () => result(),
          child: Container(
            height: Constant.height / 12,
            width: Constant.width,
            child: whereIsFlatButton(),
          ),
        ),
      ),
    );
  }
}

class GoogleButton extends StatefulWidget {
  @override
  GoogleButtonState createState() => GoogleButtonState();
}

class GoogleButtonState extends State<GoogleButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(50.0),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.white,
        ),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.grey[200],
          borderRadius: BorderRadius.circular(50.0),
          onTap: () => GoogleWay().signInWithGoogle(context).then((user) {
            if (user != null) {
              if (this.mounted)
                setState(() {
                  print('Logged in successfully');
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Menu()));
                });
            } else
              print('Login Canceled');
          }),
          child: Container(
            height: Constant.height / 12,
            width: Constant.width / 1.5,
            child: Row(
              children: <Widget>[
                SizedBox(width: Constant.width / 12),
                Container(
                  child: Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 35.0),
                ),
                SizedBox(width: Constant.width / 10),
                Center(
                  child: Text(
                    'Google',
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
