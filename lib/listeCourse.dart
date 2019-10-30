import 'package:bonap/ingredients.dart';
import 'package:flutter/material.dart';
import 'repas.dart';

class ListeCourse {
  static List<IngredientListeCourse> liste = new List<IngredientListeCourse>();

  static void addRepasToListe(Repas r) {
    bool weCanAddIt = true;
    for (int i = 0; i < r.listIngredient.length; i++) {
      for (int j = 0; j < ListeCourse.liste.length; j++) {
        if (ListeCourse.liste[j].i.nom == r.listIngredient[i].nom) {
          weCanAddIt = false;
          if (!ListeCourse.liste[j].repas.contains(r))
            ListeCourse.liste[j].repas.add(r);
        }
      }
      if (weCanAddIt) {
        ListeCourse.liste
            .add(new IngredientListeCourse(r.listIngredient[i], r));
      }

      weCanAddIt = true;
    }
  }

  static String afficher() {
    String a = '';
    for (int i = 0; i < ListeCourse.liste.length; i++) {
      a += ListeCourse.liste[i].i.nom;
    }
    return a;
  }
}

class IngredientListeCourse {
  Ingredient i;
  List<Repas> repas =
      new List<Repas>(); // Tous les repas qui utilisent l'ingredient

  IngredientListeCourse(Ingredient i, Repas r) {
    this.i = i;
    this.repas.add(r);
  }

  String afficherRepas() {
    String a = '';
    for (int b = 0; b < repas.length; b++) {
      a += ('\n' + repas[b].nom);
    }
    return a;
  }
}

class ListeCoursePage extends StatefulWidget {
  @override
  _ListeCoursePageState createState() => new _ListeCoursePageState();
}

class _ListeCoursePageState extends State<ListeCoursePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Liste de courses'),
        ),
        body: new Column(
          children: <Widget>[
            Expanded(
              child: displayIngr(),
            )
          ],
        ));
  }

  ListView displayIngr() {
    return ListView(
      shrinkWrap: true,
      children: ListeCourse.liste
          .map(
            (data) => new Container(
              child: ExpansionTile(
                title: Text(data.i.nom),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      //ListeCourse.liste.remove(data.i);
                    });
                  },
                ),
                children: <Widget>[
                  Text(data.afficherRepas()),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
