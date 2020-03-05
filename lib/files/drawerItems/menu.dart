import 'dart:io';

import 'package:bonap/files/data/dataStorage.dart';
import 'package:bonap/files/login/forms.dart';
import 'package:bonap/files/login/mainMenu.dart';
import 'package:bonap/files/tools.dart';
import 'package:bonap/files/ui/drawer.dart';
import 'package:bonap/files/widgets/dayMenu.dart';
import 'package:flutter/material.dart';

class MenuSemaine {
  static String getTheNDayOfTheWeek(int n) {
    DateTime now = DateTime.now();
    DateTime newDate =
        now.add(Duration(days: -(now.weekday - n - (7 * Weeks.weekID))));

    return newDate.day.toString() + '/' + newDate.month.toString();
  }
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  void initState() {
    super.initState();
    loading().whenComplete(() {
      setState(() {});
    });

  }

  Future<void> loading() async {
    await DataStorage.loadIngredients();
    await DataStorage.loadRepas();
    await DataStorage.loadWeek();
    await DataStorage.loadWeekNumber();
    Weeks.updateWeekNumber();
  }

  Future<bool> onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Voulez-vous vraiment vous déconnecter ?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("ANNULER"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    LoginTools.loggout = true;
                    return MainMenu();
                  })),
                ),
              ],
            ));
  }



  @override
  Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: onBackPressed,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Menu de la semaine",
                style: TextStyle(
                    fontFamily: "Lemonada",
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.black),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                      OwnColor.yellowLogo,
                      OwnColor.blueLogo
                    ])),
              ),
              actions: <Widget>[
                PopupMenuButton<String>(
                  onSelected: (String result) {
                    result == "lost"
                        ? FormsState().alertDialog(
                            "Pour organiser tes petits plats il faut ...",
                            "Ajouter tes ingrédients\n\nFabriquer d'incroyables repas\n\nPlannifier tes menus\n\nSavourer comme il se doit\n\nEt Bonap hein !",
                            FlatButton(
                              child: Text("J'ai tout compris !"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            context)
                        : FormsState().alertDialog(
                            "Tout supprimer ?",
                            "",
                            Row(
                              children: <Widget>[
                                FlatButton(
                                  child: Text('Oulà, non !',
                                      style: TextStyle(
                                        fontFamily: "Lemonada",
                                      )),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text('Ouaip',
                                      style: TextStyle(
                                        fontFamily: "Lemonada",
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      Weeks.week0 = new List<Day>(14);
                                      Weeks.week1 = new List<Day>(14);
                                      Weeks.week2 = new List<Day>(14);
                                      if (Weeks.weekID != -1)
                                        Day.listDay = new List<Day>(14);
                                      DataStorage.saveWeek();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                            context);
                  },
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: "lost",
                      child: Text("Besoin d'aide ?",
                          style: TextStyle(
                            fontFamily: "Lemonada",
                          )),
                    ),
                    const PopupMenuItem<String>(
                      value: "deleteAll",
                      child: Text('Tout effacer ?',
                          style: TextStyle(
                            fontFamily: "Lemonada",
                          )),
                    ),
                  ],
                ),
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
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: OwnColor.blueLogo,
            ),
            drawer: AppDrawer(),
            body: GestureDetector(
              onHorizontalDragStart: (details) {
                if (details.globalPosition.dx < 200)  {
                  if (Weeks.weekID > -1) {
                    setState(() {
                      Weeks.changeWeek('-');                 
                    });
                  }
                  
                }
                if (details.globalPosition.dx >= 250) {
                  if (Weeks.weekID < 2) {
                    setState(() {
                      Weeks.changeWeek('+');
                    });
                  }
                }
              },

              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.keyboard_arrow_left),
                            tooltip: "Semaine précédente",
                            color: Weeks.weekID > -1
                                ? OwnColor.blueLogo
                                : Theme.of(context).disabledColor,
                            onPressed: Weeks.weekID > -1
                                ? () {
                                    setState(() {
                                      Weeks.changeWeek('-');
                                    });
                                  }
                                : () {}),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            'Semaine du ' +
                                MenuSemaine.getTheNDayOfTheWeek(1).toString() +
                                ' au ' +
                                MenuSemaine.getTheNDayOfTheWeek(7).toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Lemonada",
                              fontSize: 22.0,
                              color: OwnColor.blueLogo,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_right),
                          tooltip: "Semaine suivante",
                          color: Weeks.weekID < 2
                              ? OwnColor.blueLogo
                              : Theme.of(context).disabledColor,
                          onPressed: Weeks.weekID < 2
                              ? () {
                                  setState(() {
                                    Weeks.changeWeek('+');
                                  });
                                }
                              : () {},
                        ),
                      ],
                    )),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          WeekMenu(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  Future navigateToSubPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainMenu()));
  }
}
