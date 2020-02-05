import 'package:bonap/custom/custom_icons.dart';
import 'package:bonap/files/drawerItems/checkup.dart';
import 'package:bonap/files/drawerItems/feedback.dart';
import 'package:bonap/files/drawerItems/ingredients.dart';
import 'package:bonap/files/drawerItems/meal.dart';
import 'package:bonap/files/drawerItems/settings.dart';
import 'package:bonap/files/drawerItems/shoppingList.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                Color.fromRGBO(205, 225, 0, 1),
                Color.fromRGBO(0, 191, 255, 1),
              ])),
              child: Image.asset(
                'assets/icon/icon7.png',
                width: double.infinity,
              )),
          Expanded(
              child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                leading: Icon(Custom.roast_turkey),
                title: Text('Repas'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => RepasPage()));
                },
              ),
              ListTile(
                leading: Icon(Custom.harvest),
                title: Text('Ingrédients'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              IngredientsPage()));
                },
              ),
              ListTile(
                leading: Icon(Custom.basket),
                enabled: false,
                title: Text('Liste de Course'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ListeCoursePage()));
                },
              ),
              ListTile(
                leading: Icon(Custom.chart_line),
                enabled: false,
                title: Text('Bilan diététique'),             
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Checkup()));
                },
              ),
            ],
          )),
          Container(
              child: Align(
            child: Column(
              children: <Widget>[
                Divider(
                  thickness: 1.0,
                ),
                ListTile(
                  leading: Icon(Custom.feedback),
                  title: Text('Feedback'),
                  enabled: false,
                  onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => FeedbackReport()));
                },
                ),
                ListTile(
                  leading: Icon(Custom.settings),
                  title: Text('Paramètres'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Settings()));
                  },
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
