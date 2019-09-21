import 'package:bonap/presentation/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//Pages
import './about.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Bonap\''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            const Image(
              alignment: Alignment.topCenter,

              image: AssetImage('assets/logo_bonap_blue.png'),


            ),
            new ListTile(
              leading: Icon(Custom.restaurant_menu),
              title: new Text('Menu'),
              onTap: () {

              },
            ),
            new ListTile(
              leading: Icon(Custom.food),
              title: new Text('Repas'),
              onTap: () {

              },
            ),
            new ListTile(
              leading: Icon(Custom.format_list_bulleted),
              title: new Text('Ingrédients'),
              onTap: () {

              },
            ),
            new ListTile(
              leading: Icon(Custom.basket),
              title: new Text('Liste de Course'),
              onTap: () {

              },
            ),
            new ListTile(
              leading: Icon(Custom.chart_line),
              title: new Text('Bilan diététique'),
              onTap: () {

              },
            ),
            new ListTile(
              leading: Icon(Custom.feedback),
              title: new Text('Feedback'),
              onTap: () {

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
                        builder: (BuildContext context) => new AboutPage()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Image(
              alignment: Alignment.topCenter,
              image: AssetImage('assets/logo_bonap.png'),
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
                        tooltip: 'Git',
                      ),
                      FloatingActionButton(
                        child: Icon(Custom.trello),
                        onPressed: _launchURLTrello,
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
