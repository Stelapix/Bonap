import 'package:flutter/material.dart';
import 'package:bonap/custom/custom_icons.dart';

//Pages

import '../repas.dart';
import '../ingredients.dart';
import '../listeCourse.dart';
import '../bilan.dart';
import '../feedback.dart';
import '../settings.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
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
                title: Text('Bilan diététique'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => BilanPage()));
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
                  color: Colors.white,
                ),
                ListTile(
                  leading: Icon(Custom.feedback),
                  title: Text('Feedback'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => FeedbackPage()));
                  },
                ),
                ListTile(
                  leading: Icon(Custom.settings),
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => SettingsPage()));
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
