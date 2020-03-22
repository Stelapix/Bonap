import 'package:bonap/files/drawerItems/shoppingList.dart';
import 'package:bonap/files/tools.dart';
import 'package:bonap/files/data/dataStorage.dart';
import 'package:bonap/files/drawerItems/meal.dart';
import 'package:bonap/files/login/mainMenu.dart';
import 'package:bonap/files/widgets/dayMenu.dart';
import 'package:bonap/files/widgets/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ingredients.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> resetPassword() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await auth.sendPasswordResetEmail(email: user.email);
  }

  //AlertDialogue qui relance la page Login
  Future<bool> alertDialog(String texte, BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar:  AppBar(
        title: Text(
                "Paramètres",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.black),
              ),
        flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                      OwnColor.yellowLogo,
                      OwnColor.blueLogo
                    ])),
              ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20.0),
            Text("     Préférences"),
            SizedBox(height: 10.0),
            ListTile(
              title: Text(
                'Mode Nuit',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              onTap: () {
                setState(() {
                  if (LoginTools.darkMode) {
                    LoginTools.darkMode = false;
                    _themeChanger.setTheme(ThemeData.light());
                  }else {
                    LoginTools.darkMode = true;
                    _themeChanger.setTheme(ThemeData.dark());
                  }
                  DataStorage.saveTheme();
                });
              },
              trailing: Switch(
                value: LoginTools.darkMode,
                onChanged: (value) {
                  setState(() {
                    LoginTools.darkMode = value;
                    if (LoginTools.darkMode)
                      _themeChanger.setTheme(ThemeData.dark());
                    else {
                      _themeChanger.setTheme(ThemeData.light());
                    }
                    DataStorage.saveTheme();
                  });
                },
                activeTrackColor: Colors.grey[300],
                activeColor: Colors.white,
              ),
            ),
            ListTile(
              title: Text(
                'Mode Végétarien',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              onTap: () {
                setState(() {
                  if (LoginTools.vege) LoginTools.vege = false;
                  else LoginTools.vege = true;
                  DataStorage.saveVege();
                });
              },
              trailing: Switch(
                value: LoginTools.vege,
                onChanged: (value) {
                  setState(() {
                    LoginTools.vege = value;
                    DataStorage.saveVege();
                  });
                },
                activeTrackColor: Colors.yellow[300],
                activeColor: Colors.yellow,
              ),
            ),
            Divider(
              thickness: 1.0,
            ),
            SizedBox(height: 10.0),
            Text("     Paramètres généraux"),
            SizedBox(height: 10.0),
            LoginTools.guestMode
                ? Container()
                : ListTile(
                    title: Text(
                      "Changer de mot de passe",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    onTap: () {
                      resetPassword();
                      alertDialog(
                          "Un email de réinitialisation va vous être envoyé",
                          context);
                    },
                  ),
            ListTile(
              title: Text(
                "Supprimer les données",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              onTap: () {
                Ingredient.listIngredients
                    .removeRange(0, Ingredient.listIngredients.length);
                Meal.listMeal.removeRange(0, Meal.listMeal.length);
                ShoppingList.liste.removeRange(0, ShoppingList.liste.length);
                DataStorage.saveIngredients();
                DataStorage.saveRepas();
                DataStorage.saveShopping();
              },
            ),
            ListTile(
              title: Text(
                LoginTools.guestMode ? "Quitter" : "Déconnexion",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              onTap: () {
                Meal.listMeal = new List<Meal>();
                Ingredient.listIngredients = new List<Ingredient>();
                LoginTools.vege = false;
                LoginTools.darkMode = true;
                ShoppingList.liste = new List<IngredientShoppingList>();
                Weeks.week_1 = new List<Day>(14);
                Weeks.week0 = new List<Day>(14);
                Weeks.week1 = new List<Day>(14);
                Weeks.week2 = new List<Day>(14);
                Day.listDay = new List<Day>(14);
                
                _themeChanger.setTheme(ThemeData.dark());          
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  LoginTools.loggout = true;
                  return MainMenu();
                }));
              },
            ),
            SizedBox(height: 20.0),
            Divider(
              thickness: 1.0,
            ),
            SizedBox(height: 10.0),
            Text("     À propos"),
            SizedBox(height: 20.0),
            ListTile(
              title: Text(
                "Crédits",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext contexte) {
                    return AlertDialog(
                      title: Text(
                        "Crédits",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      content: SizedBox(
                        height: Constant.height / 2,
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Développeurs",
                              style: TextStyle(color: Colors.amber),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text("Aymeric    "),
                                InkWell(
                                  child: Image.asset("assets/linkedin_logo.png",
                                      width: Constant.width /
                                          10,
                                      height:
                                          Constant.height /
                                              10),
                                  onTap: () => launch(
                                      'https://www.linkedin.com/in/aymericlefeyer/'),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text("Quentin     "),
                                InkWell(
                                  child: Image.asset("assets/linkedin_logo.png",
                                      width: Constant.width /
                                          10,
                                      height:
                                          Constant.height /
                                              10),
                                  onTap: () => launch(
                                      'https://www.linkedin.com/in/quentincarry/'),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Réseaux Sociaux",
                              style: TextStyle(color: Colors.red),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text("Louise     "),
                                InkWell(
                                  child: Image.asset(
                                      "assets/instagram_logo.png",
                                      width: Constant.width /
                                          10,
                                      height:
                                          Constant.height /
                                              10),
                                  onTap: () => launch(
                                      'https://www.instagram.com/louisehennecart_/?hl=fr'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              title: Text(
                "Version de Bonap",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              subtitle: Text("Version : " + Constant.version),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
