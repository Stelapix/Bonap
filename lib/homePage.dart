import 'package:bonap/widgets/account/login.dart';
import 'package:flutter/material.dart';

// Widgets
import 'widgets/drawer.dart';
import 'widgets/calendrier.dart';
import 'widgets/dropDownButtons/dropDownButtonMain.dart';

enum popUpMenu { deconnexion }

class HomePage extends StatelessWidget {
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
                    DropDownButtonMain(),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '\nLundi\n'
                          '\nMardi\n'
                          '\nMercredi\n'
                          '\nJeudi\n'
                          '\nVendredi\n'
                          '\nSamedi\n'
                          '\nDimanche\n',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white),
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
                color: null,
              ),
            ],
          ),
        ));
  }

  Future navigateToSubPage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}

/*

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

 */