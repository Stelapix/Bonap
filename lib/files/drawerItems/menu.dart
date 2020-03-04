import 'package:bonap/files/data/dataStorage.dart';
import 'package:bonap/files/drawerItems/meal.dart';
import 'package:bonap/files/drawerItems/shoppingList.dart';
import 'package:bonap/files/login/mainMenu.dart';
import 'package:bonap/files/tools.dart';
import 'package:bonap/files/ui/drawer.dart';
import 'package:bonap/files/ui/dropDownButtons/dropDownButton.dart';
import 'package:bonap/files/widgets/dayMenu.dart';
import 'package:flutter/material.dart';

class MenuSemaine {
  static String getTheNDayOfTheWeek(int n) {
    DateTime now = DateTime.now();
    DateTime newDate = now.add(Duration(days: -(now.weekday - n)));
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
    await DataStorage.loadShopping();
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
                    fontSize: 17.0,
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
                DropDownButtonMenu(contextMenu: context),
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
            body: SingleChildScrollView(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                            fontSize: 17.0,
                            color: OwnColor.blueLogo,
                          ),
                        ),
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
            )));
  }

  Future navigateToSubPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainMenu()));
  }
}
