import 'package:bonap/presentation/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Pages
import './repas.dart';
import './ingredients.dart';
import './listeCourse.dart';
import './bilan.dart';
import './feedback.dart';
import './settings.dart';

void main() async {
  /* Bloquer l'affichage Horizontal */
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});

  String title;
  IconData icon;
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Déconnexion', icon: Icons.home),
];

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int _counter = 1;

  void _incrementCounter() {
    if (_counter < 4) {
      setState(() {
        _counter++;
      });
      _onChangedColor();
    }
  }

  void _decrementCounter() {
    if (_counter > 1) {
      setState(() {
        _counter--;
        _onChangedColor();
      });
    }
  }

  ///////////////////////////////////////

  List<Color> _colors = [
    Color.fromRGBO(0, 191, 255, 1),
    Color.fromRGBO(205, 225, 0, 1),
  ];

  int _currentIndex = 0;

  _onChangedColor() {
    setState(() {
      if (_currentIndex == 0) {
        _currentIndex = 1;
      } else {
        _currentIndex = 0;
      }
    });
  }

  ///////////////////////////////////////

  String _value;
  List<String> _midiSoir = new List<String>();

  void initState() {
    _midiSoir.addAll(["Midi", "Soir"]);
    _value = _midiSoir.elementAt(0);
  }

  void _onChanged(String value) {
    setState(() {
      _value = value;
    });
  }

  ///////////////////////////////////////

  CustomPopupMenu _selectedChoices = choices[0];

  void _select(CustomPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
    });
  }

  ///////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Menu de la semaine",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.black),
        ),
        actions: <Widget>[
          PopupMenuButton(
            elevation: 3.2,
            initialValue: choices[0],
            tooltip: 'Option de déconnexion',
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((CustomPopupMenu choice) {
                return PopupMenuItem<CustomPopupMenu>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          )
        ],
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: _colors[_currentIndex],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
                  Color.fromRGBO(205, 225, 0, 1),
                  Color.fromRGBO(0, 191, 255, 1),
                ])),
                child: Image.asset(
                  'assets/icon/icon7.png',
                  width: 90,
                  height: 90,
                )),
            ListTile(
              leading: Icon(Custom.restaurant_menu),
              title: Text('Menu'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
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
                        builder: (BuildContext context) => IngredientsPage()));
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
                        builder: (BuildContext context) => ListeCoursePage()));
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
            Divider(
              height: 70.0,
              color: Color(0x00000000),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                thickness: 1.0,
                color: Colors.white,
              ),
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
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('Repas du :  ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _colors[_currentIndex],
                          fontSize: 25.0)),
                  DropdownButton(
                    value: _value,
                    items: _midiSoir.map((String value) {
                      return new DropdownMenuItem(
                          value: value,
                          child: new Row(children: <Widget>[
                            Text('$value',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0)),
                          ]));
                    }).toList(),
                    onChanged: (String value) {
                      _onChanged(value);
                    },
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1.0,
              color: _colors[_currentIndex],
            ),
            Text(
              '\nLundi\n\nMardi\n\nMercredi\n\nJeudi\n\nVendredi\n\nSamedi\n\nDimanche\n',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            Divider(
              thickness: 1.0,
              color: _colors[_currentIndex],
            ),
            Divider(
              height: 20.0,
              color: Color(0x00000000),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  backgroundColor: _colors[_currentIndex],
                  elevation: 20.0,
                  onPressed: () {
                    _decrementCounter();
                  },
                  heroTag: "<",
                  tooltip: 'Décrémenter',
                  mini: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  child: Icon(Icons.arrow_back_ios),
                ),
                Text(
                  'Semaine $_counter',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                FloatingActionButton(
                  backgroundColor: _colors[_currentIndex],
                  elevation: 20.0,
                  onPressed: () {
                    _incrementCounter();
                  },
                  heroTag: ">",
                  tooltip: 'Incrémenter',
                  mini: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*
        
        

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      '\n  Lundi\n\n  Mardi\n\n  Mercredi\n\n  Jeudi\n\n  Vendredi\n\n  Samedi\n\n  Dimanche',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    )),
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
*/
