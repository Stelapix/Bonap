import 'package:bonap/homePage.dart';
import 'package:bonap/widgets/account/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:vibration/vibration.dart';

import 'package:bonap/widgets/dataStorage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.loggout}) : super(key: key);

  final loggout;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Clé du formulaire
  final formKey = GlobalKey<FormState>();

  //Authentification à Firebase
  final FirebaseAuth auth = FirebaseAuth.instance;

  //Paramètres Google
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  bool isGoogleSignIn = false;

  //Paramètres Facebook
  final FacebookLogin facebookSignIn = new FacebookLogin();
  bool isFacebookSignIn = false;

  //Les variables contenant l'Email et le mot de passe
  TextEditingController emailController;
  TextEditingController passwordController;

  // Initialisation des messages d'erreurs
  String errorMessage = '';
  String successMessage = '';

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");
    if (widget.loggout == true) {
      signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Center(
              child: new Image.asset(
                'assets/splash/splash2.jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 200),
              child: Container(
                height: MediaQuery.of(context).size.height / 2 +
                    MediaQuery.of(context).size.height / 6,
                width: MediaQuery.of(context).size.width - 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23.0),
                  color: Colors.white.withOpacity(0.8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 10.0),
                            buildTextField("Adresse Email"),
                            SizedBox(height: 10.0),
                            buildTextField("Mot de passe"),
                            SizedBox(height: 15.0),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            const SizedBox(width: 117.0),
                            Text(
                              "Mot de passe oublié ?",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      buttonConnexion(),
                      SizedBox(height: 20.0),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Pas encore inscrit ?",
                              style: TextStyle(color: Colors.black),
                            ),
                            GestureDetector(
                                child: Text(" Inscrivez-vous",
                                    style: TextStyle(color: Color(0xFFEE5623))),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              RegisterPage(
                                                  validateAndSave,
                                                  signInWithEmail,
                                                  vibration,
                                                  loginFailed)));
                                }),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _signInGoogleButton(),
                          SizedBox(width: 5.0),
                          _signInFacebookButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Pour cacher/afficher le mot de passe
  bool isHidden = true;

  void toggleVisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  //Vérifier qu'une fois le formulaire bien remplit, l'utilisateur existe dans la bdd
  int validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      return 0;
    } else {
      return 1;
    }
  }

  //Les 2 champs de saisies pour l'adresse Mail et le mot de passe
  Widget buildTextField(String hintText) {
    return TextFormField(
      enableInteractiveSelection: true,
      validator: (value) {
        if (value.isEmpty && hintText == 'Adresse Email') {
          print("Email required");
          return 'Vous devez saisir une adresse email.';
        } else if (value.isEmpty && hintText == 'Mot de passe') {
          print("Password required");
          return 'Vous devez saisir un mot de passe.';
        } else if (hintText == 'Adresse Email' &&
            !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value)) {
          return "Format d'adresse email invalide.";
        } else if (hintText == 'Mot de passe' && value.length < 6) {
          return "Votre mot de passe doit comporter\nau moins 6 caractères.";
        } else {
          return null;
        }
      },
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Color(0xFFEE5623))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Color(0xFFEE5623))),
        prefixIcon: hintText == "Adresse Email"
            ? Icon(Icons.email, color: Colors.black)
            : Icon(Icons.lock, color: Colors.black),
        suffixIcon: hintText == "Mot de passe"
            ? IconButton(
                color: Colors.black,
                onPressed: toggleVisibility,
                icon: isHidden
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              )
            : null,
      ),
      obscureText: hintText == "Mot de passe"
          ? isHidden
          : hintText == "Adresse Email" ? false : isHidden,
      controller:
          hintText == "Adresse Email" ? emailController : passwordController,
    );
  }

  //AlertDialogue identifiants incorrects qui relance la page Login
  Future<bool> loginFailed(String texte, BuildContext context) {
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

  //Vibrer en cas d'identifiants incorrects
  void vibration() {
    if (Vibration.hasVibrator() != null &&
        Vibration.hasAmplitudeControl() != null) {
      Vibration.vibrate(duration: 200, amplitude: 20);
    }
  }

  //Bouton 'Connectez-vous'
  Widget buttonConnexion() {
    return Material(
      animationDuration: const Duration(seconds: 10),
      borderRadius: BorderRadius.circular(20.0),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
              colors: [Color(0xFFFB415B), Color(0xFFEE5623)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft),
        ),
        child: InkWell(
          onTap: () {},
          // onTap: () async {
          //   if (validateAndSave() == 0) {
          //     bool res = await signInWithEmail(
          //         emailController.text, passwordController.text, context);
          //     if (!res) {
          //       vibration();
          //       print("Login failed");
          //       await loginFailed(
          //           "Identifiants incorrects.\nMerci de réessayer.", context);
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (BuildContext context) => LoginPage()));
          //     }
          //   }
          // },
          child: Container(
            height: 50.0,
            child: new Center(
              child: new Text(
                'Connexion',
                style: new TextStyle(fontSize: 22.0, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Bouton connexion de Google
  Widget _signInGoogleButton() {
    return DecoratedBox(
      decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          color: Colors.white),
      child: OutlineButton(
        onPressed: () {
          _googleSignIn(context).then((user) {
            if (user != null) {
              print('Logged in successfully.');
              if (this.mounted) {
                setState(() {
                  isGoogleSignIn = true;
                  successMessage = 'Logged in successfully';
                  // Load les ingredients
                  DataStorage.loadIngredients();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()));
                });
              }
            } else {
              print('Login Canceled');
            }
          });
        },
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0),
        ),
        highlightElevation: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  'Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //Bouton connexion de Facebook
  Widget _signInFacebookButton() {
    return DecoratedBox(
      decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          color: Color(0xff3b5998)),
      child: OutlineButton(
        onPressed: () {
          _facebookSignIn(context).then((user) {
            if (user != null) {
              print('Logged in successfully.');
              // Load les ingredients
              DataStorage.loadIngredients();
              if (this.mounted) {
                setState(() {
                  isFacebookSignIn = true;
                  successMessage = 'Logged in successfully';
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()));
                });
              }
            } else {
              print('Login Canceled');
            }
          });
        },
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0),
        ),
        splashColor: Colors.white.withOpacity(0),
        highlightElevation: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/facebook_logo.png"), height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Text(
                  'Facebook',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //Se connecter sur Bonap
  Future<bool> signInWithEmail(String email, String password, context) async {
    if (email.contains(" ")) {
      email = email.substring(0, email.indexOf(" "));
    }
    try {
      AuthResult result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      if (user != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              // Load les ingredients
              DataStorage.loadIngredients();

              return HomePage();
            },
          ),
        );
        print(user);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //Se connecter via Facebook
  Future<FirebaseUser> _facebookSignIn(BuildContext context) async {
    FirebaseUser currentUser;
    try {
      final FacebookLoginResult result =
          await facebookSignIn.logInWithReadPermissions(['email']);

      final FacebookAccessToken accessToken = result.accessToken; //Erreur

      final AuthCredential credential =
          FacebookAuthProvider.getCredential(accessToken: accessToken.token);

      final FirebaseUser user =
          (await auth.signInWithCredential(credential)).user;
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
      print(currentUser);
      print("User Name  : ${currentUser.displayName}");
    } catch (e) {
      print(e);
    }
    return currentUser;
  }

  //Se connecter via Google
  Future<FirebaseUser> _googleSignIn(BuildContext context) async {
    FirebaseUser currentUser;
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await auth.signInWithCredential(credential)).user;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
      print(currentUser);
      print("User Name  : ${currentUser.displayName}");
    } catch (e) {
      print(e);
    }
    return currentUser;
  }

  //Se déconnecter de Facebook et Google
  Future<bool> signOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
    await facebookSignIn.logOut();
    print("User Sign Out");
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
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.left,
        ),
        backgroundColor: Colors.white.withOpacity(0.9),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "ANNULER",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.black),
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
