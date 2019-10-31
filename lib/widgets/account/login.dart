import 'package:bonap/homePage.dart';
import 'package:bonap/register.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = new GoogleSignIn();
bool isGoogleSignIn = false;
// Gérer les erreurs
String errorMessage = '';
String successMessage = '';

TextEditingController _emailController;
TextEditingController _passwordController;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset(
              'assets/splash/splash2.jpg',
              width: size.width,
              height: size.height,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: 620.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 200),
              // 30 30 200 50
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23.0),
                  color: Colors.white.withOpacity(0.8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10.0),
                      buildTextField("Adresse Email"),
                      const SizedBox(height: 10.0),
                      buildTextField("Mot de passe"),
                      SizedBox(height: 20.0),
                      Container(
                        child: Row(
                          children: <Widget>[
                            const SizedBox(width: 98.0),
                            Text(
                              "Mot de passe oublié ?",
                              style: TextStyle(
                                color:Color(0xFFEE5623),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      buildButtonContainer(),
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
                                child: Text(
                                  " Inscrivez-vous",
                                  style: TextStyle(color:Color(0xFFEE5623))
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              RegisterPage()));
                                }
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      _signInButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Widget buildTextField(String hintText) {
    return TextField(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: hintText == "Adresse Email"
            ? Icon(Icons.email, color: Colors.black)
            : Icon(Icons.lock, color: Colors.black),
        suffixIcon: hintText == "Mot de passe"
            ? IconButton(
                color: Colors.black,
                onPressed: _toggleVisibility,
                icon: _isHidden
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              )
            : null,
      ),
      obscureText: hintText == "Mot de passe"
          ? _isHidden
          : hintText == "Adresse Email" ? false : _isHidden,
      controller:
          hintText == "Adresse Email" ? _emailController : _passwordController,
    );
  }

  Widget buildButtonContainer() {
    return InkWell(
      onTap: () async {
        if (_emailController.text.isEmpty) {
          print("Email required");
        } else if (_passwordController.text.isEmpty) {
          print("Password required");
        } else {
          bool res = await signInWithEmail(
              _emailController.text, _passwordController.text, context);
          if (!res) {
            print("Login failed");
          }
        }
      },
      child: new Container(
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
              colors: [Color(0xFFFB415B), Color(0xFFEE5623)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft),
        ),
        child: new Center(
          child: new Text(
            'Connectez-vous',
            style: new TextStyle(fontSize: 22.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return DecoratedBox(
      decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          color: Colors.white),
      child: OutlineButton(
        onPressed: () {
          googleSignin(context).then((user) {
            if (user != null) {
              print('Logged in successfully.');
              if (this.mounted) {
                setState(() {
                  isGoogleSignIn = true;
                  successMessage = 'Logged in successfully';
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()));
                });
              }
            } else {
              print('Error while Login.');
            }
          });
        },
        highlightElevation: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 20),
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

  Future<FirebaseUser> googleSignin(BuildContext context) async {
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
      handleError(e);
    }
    return currentUser;
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_USER_NOT_FOUND':
        setState(() {
          errorMessage = 'User Not Found!!!';
        });
        break;
      case 'ERROR_WRONG_PASSWORD':
        setState(() {
          errorMessage = 'Wrong Password!!!';
        });
        break;
    }
  }
}

Future<bool> googleSignout() async {
  await auth.signOut();
  await googleSignIn.signOut();
  print("---------------------> User Sign Out");
  return true;
}
