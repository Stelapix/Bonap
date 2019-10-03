import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

// Widgets
import 'widgets/drawer.dart';
import 'widgets/calendrier.dart';
import 'widgets/dropDownButton.dart';

void main() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]); // Désactiver l'orientation horizontale
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false, // Retirer le bandeau de debug
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

enum popUpMenu { deconnexion }

class _HomePage extends State<HomePage> {
  final bleu = Color.fromRGBO(0, 191, 255, 1);
  final jaune = Color.fromRGBO(205, 225, 0, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Menu de la semaine",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23.0,
                color: Colors.black),
          ),
          actions: <Widget>[
            PopupMenuButton<popUpMenu>(
              elevation: 3.2,
              tooltip: 'Option de déconnexion',
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<popUpMenu>>[
                const PopupMenuItem<popUpMenu>(
                  value: popUpMenu.deconnexion,
                  child: Text('Déconnexion'),
                ),
              ],
            )
          ],
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: 'Afficher le drawer',
              );
            },
          ),
          iconTheme: new IconThemeData(color: Colors.black),
          backgroundColor: bleu,
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Repas du :  ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: bleu,
                            fontSize: 20.0)),
                    DropDownButton(),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                    colors: <Color>[
                      jaune,
                      bleu,
                    ],
                  ),
                ),
                padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '\nLundi                                                                         \n\nMardi\n\nMercredi\n\nJeudi\n\nVendredi\n\nSamedi\n\nDimanche\n',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1.0,
                color: null,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                    colors: <Color>[
                      jaune,
                      bleu,
                    ],
                  ),
                ),
                child: Calendrier(),
              ),
              Divider(
                thickness: 1.0,
                color: bleu,
              ),
            ],
          ),
        ));
  }
}

/*

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

  void _onChanged(String value) {
    setState(() {
      _value = value;
    });
  }


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
                          fontSize: 20.0)),
                  DropdownButton(
                    value: _value,
                    items: _midiSoir.map((String value) {
                      return new DropdownMenuItem(
                          value: value,
                          child: new Row(children: <Widget>[
                            Text('$value',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
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
                  tooltip: 'Semaine Précédente',
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
                  tooltip: 'Semaine Suivante',
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
