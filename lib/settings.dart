import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'widgets/account/login.dart';
import 'ingredients.dart';
import 'repas.dart';

import 'widgets/dataStorage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  //Pour cacher/afficher le mot de passe
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Paramètres'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Mode Nuit',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                  child: Text(
                    "Supprimer les données",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Ingredient.listIngredients
                        .removeRange(0, Ingredient.listIngredients.length);
                    Meal.listMeal.removeRange(0, Meal.listMeal.length);
                    DataStorage.saveIngredients();
                    DataStorage.saveRepas();
                  }),
              SizedBox(height: 20.0),
              GestureDetector(
                  child: Text(
                    "Déconnexion",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                LoginPage(loggout: true)));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
