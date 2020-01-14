import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'widgets/account/login.dart';
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

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Paramètres'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  setState(() {
                    isSwitchedVegetarian = value;
                    if (isSwitchedVegan) isSwitchedVegan = !value;
                  });
                },
                activeTrackColor: Colors.yellow[300],
                activeColor: Colors.yellow,
              ),
            ),
            ListTile(
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
                  setState(() {
                    isSwitchedVegan = value;
                    if (isSwitchedVegetarian) isSwitchedVegetarian = !value;
                  });
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
                            LoginPage(loggout: true)));
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
              title: Text("Version de Bonap\nVersion : 0.1"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
