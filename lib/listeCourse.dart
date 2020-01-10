import 'package:bonap/ingredients.dart';
import 'package:flutter/material.dart';
import 'repas.dart';

class ListeCourse {
  static List<IngredientListeCourse> liste = new List<IngredientListeCourse>();

  static void addRepasToListe(Meal r) {
    bool weCanAddIt = true;
    for (int i = 0; i < r.listIngredient.length; i++) {
      for (int j = 0; j < ListeCourse.liste.length; j++) {
        if (ListeCourse.liste[j].i.name == r.listIngredient[i].name) {
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

  static void resetListe() {
    ListeCourse.liste.removeRange(0, ListeCourse.liste.length);
  }

  static String afficher() {
    String a = '';
    for (int i = 0; i < ListeCourse.liste.length; i++) {
      a += ListeCourse.liste[i].i.name;
    }
    return a;
  }
}

class IngredientListeCourse {
  Ingredient i;
  List<Meal> repas =
      new List<Meal>(); // Tous les repas qui utilisent l'ingredient

  IngredientListeCourse(Ingredient i, Meal r) {
    this.i = i;
    this.repas.add(r);
  }

  String afficherRepas() {
    String a = '';
    for (int b = 0; b < repas.length; b++) {
      a += ('\n' + repas[b].name);
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
                leading: Ingredient.catIcon(data.i.cat),
                title: Text(data.i.name),
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
