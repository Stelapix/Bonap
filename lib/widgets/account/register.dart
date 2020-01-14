import 'package:bonap/widgets/account/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  final Function functionLoginSize;
  final Function functionValidateAndSave;
  final Function functionSignInWithEmail;
  final Function functionVibration;
  final Function functionLoginFailed;

  RegisterPage(
      this.functionLoginSize,
      this.functionValidateAndSave,
      this.functionSignInWithEmail,
      this.functionVibration,
      this.functionLoginFailed);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  //Clé du formulaire
  final formKey = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;

  //Les variables contenant l'Email et le mot de passe
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController passwordCheckController;

  //Taille de la box
  double sizeLogin = 600.0;

  //Pour cacher/afficher le mot de passe
  bool isHidden = true;

  void toggleVisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");
    passwordCheckController = TextEditingController(text: "");
  }

  Future<bool> onBackPressed() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
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
              height: sizeLogin,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, right: 12.0, top: 200),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(23.0),
                    color: Colors.white.withOpacity(0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
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
                              SizedBox(height: 10.0),
                              buildTextField("Confirmer le mot de passe"),
                              SizedBox(height: 15.0),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        buildButtonContainer(),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  //Changer la taille de box en fonction des informations affichées
  void loginSize(double newSize) {
    setState(() {
      sizeLogin = newSize;
    });
  }

  //Les 2 champs de saisies pour l'adresse Mail et le mot de passe
  Widget buildTextField(String hintText) {
    return TextFormField(
      enableInteractiveSelection: true,
      validator: (value) {
        if (value.isEmpty && hintText == 'Adresse Email') {
          loginSize(657.0);
          print("Email required");
          return 'Vous devez saisir une adresse email.';
        } else if (value.isEmpty && hintText == 'Mot de passe') {
          loginSize(657.0);
          print("Password required");
          return 'Vous devez saisir un mot de passe.';
        } else if (value.isEmpty && hintText == 'Confirmer le mot de passe') {
          loginSize(657.0);
          print("PasswordCheck required");
          return 'Vous devez saisir le\nmot de passe de confirmation.';
        } else if (hintText == 'Adresse Email' &&
            !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value)) {
          loginSize(657.0);
          return "Format d'adresse email invalide.";
        } else if (hintText == 'Mot de passe' && value.length < 6) {
          loginSize(657.0);
          return "Votre mot de passe doit comporter\nau moins 6 caractères.";
        } else if (passwordController.text != passwordCheckController.text) {
          loginSize(657.0);
          print("Passwords are not the same");
          return 'Les mots de passes sont différents.';
        } else {
          loginSize(600.0);
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
        focusColor: Colors.orange,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Color(0xFFEE5623))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Color(0xFFEE5623))),
        prefixIcon: hintText == "Adresse Email"
            ? Icon(Icons.email, color: Colors.black)
            : hintText == "Mot de passe"
                ? Icon(Icons.lock, color: Colors.black)
                : Icon(Icons.check, color: Colors.black),
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
          hintText == "Adresse Email" ? emailController : hintText == "Mot de passe" ? passwordController : passwordCheckController,
    );
  }

  //Bouton 'Connectez-vous'
  Widget buildButtonContainer() {
    return InkWell(
      onTap: () async {
        if (validateAndSave() == 0) {
          if (emailController.text.contains(" ")) {
            emailController.text = emailController.text
                .substring(0, emailController.text.indexOf(" "));
          }
          try {
            FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)).user;
//            user.sendEmailVerification();
            print("Welcome");
            await widget.functionLoginFailed("Votre compte a été créé.\nVeuillez vous connecter.",context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage()));
          } catch (e) {
            print(e.message);
            await widget.functionLoginFailed(
                "Compte déjà existant.\nMerci de réessayer.", context);
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
            "S'inscrire",
            style: new TextStyle(fontSize: 22.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
