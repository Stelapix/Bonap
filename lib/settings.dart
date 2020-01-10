import 'package:flutter/material.dart';
import 'widgets/account/login.dart';
import 'ingredients.dart';
import 'repas.dart';

import 'widgets/dataStorage.dart';


class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(
        title: new Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RaisedButton(
              child: Text("Déconnexion"),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage(loggout: true)));
              },
            ),
            RaisedButton(
              child: Text("Reset"),
              onPressed: () {
                print("Oui");
                Ingredient.ingredients
                    .removeRange(0, Ingredient.ingredients.length);
                Repas.listRepas
                    .removeRange(0, Repas.listRepas.length);
                DataStorage.saveIngredients();
                DataStorage.saveRepas();
              },
            )
          ],
        ),
      ),
    );
  }
}