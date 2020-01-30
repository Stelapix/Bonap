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
    return Material(
      borderRadius: BorderRadius.circular(50.0),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          gradient: LinearGradient(
              colors: [OwnColor.orangeDarker, OwnColor.orange],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft),
        ),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: OwnColor.yellow,
          borderRadius: BorderRadius.circular(50.0),
          onTap: () {},
          child: Container(
            height: Constant.height / 12,
            width: Constant.width,
            child: Row(
              children: <Widget>[
                SizedBox(width: Constant.width / 12),
                Container(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    color: Colors.white,
                    child: widget.icon,
                    onPressed: () =>
                        FormsState().whichButton(widget.buttonType, context),
                  ),
                ),
                SizedBox(width: Constant.width / 10),
                Center(child: widget.buttonName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoogleButton extends StatelessWidget {
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
          onTap: () {},
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
  // return Container(
  //     width: Constant.width / 1.5,
  //     child: DecoratedBox(
  //       decoration: ShapeDecoration(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(50)),
  //           color: Colors.white),
  //       child: OutlineButton(
  //         onPressed: () {
  // _googleSignIn(context).then((user) {
  //   if (user != null) {

  //     print('Logged in successfully.');
  // if (this.mounted) {
  //   setState(() {
  //     isGoogleSignIn = true;
  //     successMessage = 'Logged in successfully';
  //     DataStorage.loadIngredients();
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (BuildContext context) => HomePage()));
  //   });
  // }
  //   } else
  //     print('Login Canceled');
  // });
  //     },
  //     borderSide: BorderSide(
  //       color: Colors.white.withOpacity(0),
  //     ),
  //     child: Container(
  //       height: Constant.height / 12,
  //       child: Row(
  //         children: <Widget>[
  //           Image(
  //               image: AssetImage("assets/google_logo.png"),
  //               height: 35.0),
  //           Center(
  //             child: Text(
  //               'Google',
  //               style: TextStyle(
  //                 fontSize: 20,
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.normal,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ),
  // ));

}
