import 'package:bonap/widgets/account/login.dart';
import 'package:flutter/material.dart';

// Widgets
import 'widgets/drawer.dart';
import 'repas.dart';
import 'ingredients.dart';
import 'listeCourse.dart';
import 'widgets/dataStorage.dart';
import 'widgets/menu/dayMenu.dart';


class MenuSemaine {
  int numSemaine;
  List<List<Meal>> repasSemaine = new List<List<Meal>>();

  // indexs de 0 a 13, de lundi midi a dimanche soir

  MenuSemaine(int numSemaine) {
    this.numSemaine = numSemaine;

    for (var i = 0; i < 14; i++) {
      repasSemaine.add(new List<Meal>());
      repasSemaine[i].add(new Meal('', new List<Ingredient>()));
    }
  }

  void choisirRepas(int a, List<Meal> r) {
    repasSemaine[a] = r;
  }

  static String getTheNDayOfTheWeek(int n) {
    DateTime now = DateTime.now();
    DateTime newDate = now.add(Duration(days: -(now.weekday - n)));
    return newDate.day.toString() + '/' + newDate.month.toString();
  }
}

class FunctionUpdate {
  static void updateListeCourse(List<List<Meal>> repasSemaine) {
    ListeCourse.resetListe();
    for (int i = 0; i < repasSemaine.length; i++) {
      for (int j = 0; j < repasSemaine[i].length; j++) {
        if (repasSemaine[i][j] != null) {
          ListeCourse.addRepasToListe(repasSemaine[i][j]);
        }
      }
    }
  }
}

// Cette ligne va disparaitre quand on loadera le menu depuis la firebase
MenuSemaine m = new MenuSemaine(49);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bleu = Color.fromRGBO(0, 191, 255, 1);
  final jaune = Color.fromRGBO(205, 225, 0, 1);

  @override
  void initState() {
    DataStorage.loadIngredients();
    DataStorage.loadRepas();
    super.initState();
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
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              LoginPage(loggout: true))),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    ListeCourse.resetListe();
    FunctionUpdate.updateListeCourse(m.repasSemaine);
    return WillPopScope(
        onWillPop: onBackPressed,
        child: Scaffold(
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
              iconTheme: IconThemeData(color: Colors.black),
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
                      Padding(
                        padding: const EdgeInsets.only(top:10, bottom: 10),
                        child: Text(
                          'Semaine du ' + MenuSemaine.getTheNDayOfTheWeek(1).toString() + ' au ' + MenuSemaine.getTheNDayOfTheWeek(7).toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26.0,
                            color: bleu,
                            fontWeight: FontWeight.bold,
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
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}

