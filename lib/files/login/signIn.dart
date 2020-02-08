import 'package:bonap/files/login/forms.dart';
import 'package:bonap/files/login/mainMenu.dart';
import 'package:bonap/files/tools.dart';
import 'package:bonap/files/ui/button/button.dart';
import 'package:bonap/files/widgets/loader.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  void initState() {
    KeyForm().newKey();
    super.initState();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.sync(MainMenuState().backToMainMenu),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: Constant.height,
                child: Column(
                  children: <Widget>[
                    Loader(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Forms(
                            whichForms: "signInForm",
                          ),
                          SizedBox(height: 30),
                          GestureDetector(
                              child: Text(
                                "Mot de passe oublié ?",
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                              onTap: () {
                                FormsState().alertPasswordReset("Nouveau mot de passe", "Saisissez votre adresse email", context);
                              }),
                          SizedBox(height: 30.0),
                          OwnButton(
                            buttonName: "Se connecter",
                            icon: Icon(
                              Icons.reply_all,
                              color: OwnColor.orangeDarker,
                            ),
                            buttonType: ButtonType.Connecter,
                          ),
                          SizedBox(height: 30.0),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: Constant.width / 6,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.25, color: Colors.white)),
                          ),
                          Text(
                            " OU CONNECTEZ-VOUS AVEC ",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            width: Constant.width / 6,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.25, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 100.0),
                            GoogleButton(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
