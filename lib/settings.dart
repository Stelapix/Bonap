import 'package:bonap/widgets/account/mainMenu.dart';
import 'package:bonap/widgets/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/account/mainMenu.dart';
import 'widgets/theme.dart';
import 'ingredients.dart';
import 'package:provider/provider.dart';
import 'repas.dart';

import 'widgets/dataStorage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  //Pour cacher/afficher le mot de passe
  bool isSwitchedNight = true;
  bool isSwitchedVegetarian = false;
  bool isSwitchedVegan = false;

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
      appBar: new AppBar(
        title: new Text('Paramètres'),
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
                  if (isSwitchedNight)
                    isSwitchedNight = false;
                  else
                    isSwitchedNight = true;
                  if (isSwitchedNight)
                    _themeChanger.setTheme(ThemeData.dark());
                  else {
                    _themeChanger.setTheme(ThemeData.light());
                  }
                });
              },
              trailing: Switch(
                value: isSwitchedNight,
                onChanged: (value) {
                  setState(() {
                    isSwitchedNight = value;
                    if (isSwitchedNight)
                      _themeChanger.setTheme(ThemeData.dark());
                    else {
                      _themeChanger.setTheme(ThemeData.light());
                    }
                  });
                },
                activeTrackColor: Colors.grey[300],
                activeColor: Colors.white,
              ),
            ),
            ListTile(
              enabled: false,
              title: Text(
                'Mode Végétarien',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              onTap: () {
                setState(() {
                  if (isSwitchedVegetarian)
                    isSwitchedVegetarian = false;
                  else
                    isSwitchedVegetarian = true;
                  if (isSwitchedVegan) isSwitchedVegan = false;
                });
              },
              trailing: Switch(
                value: isSwitchedVegetarian,
                onChanged: (value) {
                  // setState(() {
                  //   isSwitchedVegetarian = value;
                  //   if (isSwitchedVegan) isSwitchedVegan = !value;
                  // });
                },
                activeTrackColor: Colors.yellow[300],
                activeColor: Colors.yellow,
              ),
            ),
            ListTile(
              enabled: false,
              title: Text(
                'Mode Vegan',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              onTap: () {              
                setState(() {
                  if (isSwitchedVegan)
                    isSwitchedVegan = false;
                  else
                    isSwitchedVegan = true;
                  if (isSwitchedVegetarian) isSwitchedVegetarian = false;
                });
              },
              trailing: Switch(
                value: isSwitchedVegan,
                onChanged: (value) {
                  // setState(() {
                  //   isSwitchedVegan = value;
                  //   if (isSwitchedVegetarian) isSwitchedVegetarian = !value;
                  // });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ),
            Divider(
              thickness: 1.0,
            ),
            SizedBox(height: 10.0),
            Text("     Paramètres généraux"),
            SizedBox(height: 10.0),
            ListTile(
              title: Text(
                "Changer de mot de passe",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              onTap: () {
                resetPassword();
                alertDialog("Un email de réinitialisation va vous être envoyé",
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
                DataStorage.saveIngredients();
                DataStorage.saveRepas();
              },
            ),
            ListTile(
              title: Text(
                "Déconnexion",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            MainMenu(loggout: true)));
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
                        height: MediaQuery.of(context).size.height / 2,
                        child: Column(
                          children: <Widget>[
                            Text("Codeurs", style: TextStyle(color: Colors.amber),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text("Aymeric    "),
                                InkWell(
                                  child: Image.asset("assets/linkedin_logo.png",
                                      width: MediaQuery.of(context).size.width /
                                          10,
                                      height:
                                          MediaQuery.of(context).size.height /
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
                                      width: MediaQuery.of(context).size.width /
                                          10,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              10),
                                  onTap: () => launch(
                                      'https://www.linkedin.com/in/quentincarry/'),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text("Réseaux Sociaux", style: TextStyle(color: Colors.red),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text("Louise     "),
                                InkWell(
                                  child: Image.asset("assets/instagram_logo.png",
                                      width: MediaQuery.of(context).size.width /
                                          10,
                                      height:
                                          MediaQuery.of(context).size.height /
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
