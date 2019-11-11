import 'package:bonap/widgets/account/login.dart';
import 'package:flutter/material.dart';

// Widgets
import 'widgets/drawer.dart';
import 'widgets/calendrier.dart';
import 'widgets/dayDisplayMenu.dart';
import 'repas.dart';
import 'ingredients.dart';
import 'listeCourse.dart';
import 'widgets/dataStorage.dart';

enum popUpMenu { deconnexion }

class MenuSemaine {
  int numSemaine;
  List<List<Repas>> repasSemaine = new List<List<Repas>>();

  // indexs de 0 a 13, de lundi midi a dimanche soir

  MenuSemaine(int numSemaine) {
    this.numSemaine = numSemaine;

    for (var i = 0; i < 14; i++) {
      repasSemaine.add(new List<Repas>());
      repasSemaine[i].add(new Repas('', new List<Ingredient>()));
    }
  }

  void choisirRepas(int a, List<Repas> r) {
    repasSemaine[a] = r;
  }
}

class FunctionUpdate {
  static void updateListeCourse(List<List<Repas>> repasSemaine) {
    for (int i = 0; i < repasSemaine.length; i++) {
      for (int j = 0; j < repasSemaine[i].length; j++) {
        if (repasSemaine[i][j] != null) {
          print("Ajout de " + repasSemaine[i][j].nom);
          ListeCourse.addRepasToListe(repasSemaine[i][j]);
          print(ListeCourse.liste.length);
        }
      }
    }
  }
}

MenuSemaine m = new MenuSemaine(49);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bleu = Color.fromRGBO(0, 191, 255, 1);
  final jaune = Color.fromRGBO(205, 225, 0, 1);

  // Cette ligne va disparaitre quand on loadera le menu depuis la firebase

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Voulez-vous vraiment vous déconnecter ?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Non"),
                  onPressed: () =>
                    Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text("Oui"),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage(loggout: true))),
                ),
              ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    DataStorage.loadIngredients();
    DataStorage.loadRepas();
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
//              Container(
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Text('Repas du :  ',
//                        style: TextStyle(
//                            fontWeight: FontWeight.bold,
//                            color: bleu,
//                            fontSize: 20.0)),
//                    DropDownButtonMain(),
//                  ],
//                ),
//              ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Semaine ' + m.numSemaine.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26.0,
                          color: bleu,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),

                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DayDisplayMenu('Lundi', 0, 1, m),
                        DayDisplayMenu('Mardi', 2, 3, m),
                        DayDisplayMenu('Mercredi', 4, 5, m),
                        DayDisplayMenu('Jeudi', 6, 7, m),
                        DayDisplayMenu('Vendredi', 8, 9, m),
                        DayDisplayMenu('Samedi', 10, 11, m),
                        DayDisplayMenu('Dimanche', 12, 13, m),
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
            )));
  }

  Future navigateToSubPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
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
