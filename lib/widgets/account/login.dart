import 'package:bonap/widgets/account/firebase_auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Mot de passe oublié ?",
                              style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      buildButtonContainer(),
                      SizedBox(height: 20.0),
                      Container(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Pas encore inscrit ?",
                                  style: TextStyle(color: Colors.black)),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text("Inscrivez-vous",
                                  style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      GoogleSignInButton(
                        darkMode: true,
                        onPressed: () async {
                          bool res = await AuthProvider().loginWithGoogle();
                          if (!res) print("error login with Google");
                        },
                      ),
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
              ? Icon(Icons.visibility)
              : Icon(Icons.visibility_off),
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
          bool res = await AuthProvider().signInWithEmail(
              _emailController.text, _passwordController.text);
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
        child: new Center(child: new Text('Connectez-vous',
          style: new TextStyle(fontSize: 22.0, color: Colors.white),),),
      ),
    );
  }

  
}


