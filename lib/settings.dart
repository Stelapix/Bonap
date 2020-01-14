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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Préférences"),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Mode Nuit',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Switch(
                    value: isSwitchedNight,
                    onChanged: (value) {
                      setState(() {
                        isSwitchedNight = value;
                        // if(_themeChanger.getTheme() == ThemeData.dark()) isSwitchedNight = true;
                        // else isSwitchedNight = false;
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
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Mode Végétarien',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Switch(
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
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Mode Vegan',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Switch(
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
                ],
              ),
              Divider(
                thickness: 1.0,
              ),
              SizedBox(height: 10.0),
              Text("Paramètres généraux"),
              SizedBox(height: 20.0),
              GestureDetector(
                  child: Text(
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
                  }),
              SizedBox(height: 30.0),
              GestureDetector(
                  child: Text(
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
                  }),
              SizedBox(height: 20.0),
              Divider(
                thickness: 1.0,
              ),
              SizedBox(height: 10.0),
              Text("À propos"),
              SizedBox(height: 20.0),
              Text(
                "Version de Bonap",
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 5.0),
              Text("Version : 0.1"),
            ],
          ),
        ),
      ),
    );
  }
}
