import 'package:bonap/presentation/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//Pages
import './repas.dart';
import './ingredients.dart';
import './listeCourse.dart';
import './bilan.dart';
import './feedback.dart';
import './settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Menu de la semaine", style: TextStyle(color: Colors.black),),
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Color.fromRGBO(0, 191, 255, 1),
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
                  Color.fromRGBO(255, 225, 0, 1),
                  Color.fromRGBO(0, 191, 255, 1),
                ])),
                child: Image.asset(
                  'assets/icon/icon7.png',
                  width: 90,
                  height: 90,
                )),
            new ListTile(
              leading: Icon(Custom.restaurant_menu),
              title: new Text('Menu'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            new ListTile(
              leading: Icon(Custom.roast_turkey),
              title: new Text('Repas'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new RepasPage()));
              },
            ),
            new ListTile(
              leading: Icon(Custom.harvest),
              title: new Text('Ingrédients'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new IngredientsPage()));
              },
            ),
            new ListTile(
              leading: Icon(Custom.basket),
              title: new Text('Liste de Course'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new ListeCoursePage()));
              },
            ),
            new ListTile(
              leading: Icon(Custom.chart_line),
              title: new Text('Bilan diététique'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new BilanPage()));
              },
            ),
            Divider(),
            new ListTile(
              leading: Icon(Custom.feedback),
              title: new Text('Feedback'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new FeedbackPage()));
              },
            ),
            new ListTile(
              leading: Icon(Custom.settings),
              title: new Text('Settings'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new SettingsPage()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: const Image(
                alignment: Alignment.topCenter,
                image: AssetImage('assets/logo_bonap.png'),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'CARRY Quentin - LE FEYER Aymeric',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FloatingActionButton(
                        child: Icon(Custom.github_circled),
                        onPressed: _launchURLGit,
                        heroTag: "bt1",
                        tooltip: 'Git',
                      ),
                      FloatingActionButton(
                        child: Icon(Custom.trello),
                        onPressed: _launchURLTrello,
                        heroTag: "bt2",
                        tooltip: 'Trello',
                      )
                    ],
                  ),
                ),
                Text(
                  'Bonap est un gestionnaire de menu intelligent \n'
                  'Ajoutez des recettes et commencez votre menu !\n'
                  'La liste de course sera automatiquement générée\n'
                  'Une estimation du prix sera alors générée\n'
                  'Membre d\'une famille ? Ajoutez-la !\n'
                  '\n'
                  'Tout est prêt ? Dans ce cas, Bonap !',
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _launchURLGit() async {
    const url = 'https://github.com/AymericLeFeyer/Bonap';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchURLTrello() async {
    const url = 'https://trello.com/b/Vi01l5l7';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
