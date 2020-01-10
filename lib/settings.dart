import 'package:flutter/material.dart';
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
        title: new Text('Settings'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RaisedButton(
              child: Text("Déconnexion"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            LoginPage(loggout: true)));
              },
            ),
            RaisedButton(
              child: Text("Reset"),
              onPressed: () {
                print("Oui");
                Ingredient.listIngredients
                    .removeRange(0, Ingredient.listIngredients.length);
                Meal.listMeal.removeRange(0, Meal.listMeal.length);
                DataStorage.saveIngredients();
                DataStorage.saveRepas();
              },
            ),
            Row(
              children: <Widget>[
                Text(
                  'Black Mode',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
            )
          ],
        ),
      ),
    );
  }
}
