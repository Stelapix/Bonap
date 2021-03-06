import 'dart:async';

import 'package:bonap/files/data/dataStorage.dart';
import 'package:bonap/files/login/connectedWays.dart';
import 'package:bonap/files/login/signIn.dart';
import 'package:bonap/files/login/signUp.dart';
import 'package:bonap/files/tools.dart';
import 'package:bonap/files/ui/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height * 0.85);
    p.arcToPoint(
      Offset(0.0, size.height * 0.85),
      radius: const Radius.elliptical(50.0, 10.0),
    );
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class MainMenu extends StatefulWidget {
  @override
  MainMenuState createState() => new MainMenuState();
}

class MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  
  @override
  void initState() {
    super.initState();
    if (LoginTools.loggout) signOut();
    KeyForm().newKey();
    LoginTools.guestMode = false;
    DataStorage.loadUID();
    
  }

  static PageController whichPage =
      new PageController(initialPage: 1, viewportFraction: 1.0);

  void goto(int numPage) {
    whichPage.animateToPage(
      numPage,
      duration: Duration(milliseconds: 1300),
      curve: Curves.bounceOut,
    );
  }

  bool backToMainMenu() {
    MainMenuState.whichPage.animateToPage(1,
        curve: Curves.easeOutCubic, duration: Duration(milliseconds: 1150));
    return false;
  }

  void backToSignIn() {
    MainMenuState.whichPage.animateToPage(0,
        curve: Curves.slowMiddle, duration: Duration(milliseconds: 1700));
  }

  Widget menu(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: Constant.height,
                child: Column(
                  children: <Widget>[
                    ClipPath(
                      clipper: MyClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/splash/splashLogin.jpg'),
                              fit: BoxFit.fill),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 20,
                            ),
                            Image.asset(
                              'assets/logo_bonap.png',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            OwnButton(
                              buttonName: "Connexion",
                              buttonType: ButtonType.Connexion,
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: OwnColor.orange,
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height / 16),
                            OwnButton(
                              buttonName: "Inscription",
                              buttonType: ButtonType.Inscription,
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: OwnColor.orange,
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height / 16),
                            OwnButton(
                              buttonName: "Mode invité",
                              buttonType: ButtonType.Guest,
                              icon: Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10, left: 10),
                            child: Text(
                              Constant.company,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10, right: 10),
                            child: Text(
                              "v" + Constant.version,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: Constant.height,
          child: PageView(
            controller: whichPage,
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              SignIn(),
              menu(context),
              SignUp(),
            ],
            scrollDirection: Axis.horizontal,
          )),
    );
  }

  //Se déconnecter de Facebook et Google
  Future<bool> signOut() async {
    await LoginTools.auth.signOut();
    await GoogleWay().googleSignIn.signOut();
    print(LoginTools.guestMode ? "Guest Sign Out" : "User Sign Out");
    LoginTools.loggout = false;
    MainMenu();
    return true;
  }

  //Gérer le retour en arrière sur la page Login
  Future<bool> onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Voulez-vous vraiment quitter l'application ?",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.left,
        ),
        backgroundColor: OwnColor.darkBackground,
        actions: <Widget>[
          FlatButton(
            child: Text(
              "ANNULER",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                signOut();
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              }),
        ],
      ),
    );
  }
}
