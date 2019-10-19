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

  List<Color> _colors = [
    Colors.white,
    Colors.red,
  ];

  int _currentIndex = 0;

  _onChangedColor() {
    setState(() {
      if (_currentIndex == 0) {
        _currentIndex = 1;
      } else {
        _currentIndex = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 100.0),
              Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(hintText: "Adresse email"),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(hintText: "Mot de passe"),
              ),
              const SizedBox(height: 10.0),
              RaisedButton(
                child: Text("Login",
                    style: TextStyle(color: _colors[_currentIndex])),
                onPressed: () async {
                  if (_emailController.text.isEmpty) {
                    print("Email required");
                    _onChangedColor();
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
              ),
              const SizedBox(height: 20.0),
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
    );
  }
}
