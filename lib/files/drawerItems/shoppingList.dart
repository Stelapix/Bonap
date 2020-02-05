import 'package:bonap/files/drawerItems/ingredients.dart';
import 'package:bonap/files/drawerItems/meal.dart';
import 'package:flutter/material.dart';

class ShoppingList {
  static List<IngredientListeCourse> liste = new List<IngredientListeCourse>();

  static void addRepasToListe(Meal r) {
    bool weCanAddIt = true;
    for (int i = 0; i < r.listIngredient.length; i++) {
      for (int j = 0; j < ShoppingList.liste.length; j++) {
        if (ShoppingList.liste[j].i.name == r.listIngredient[i].name) {
          weCanAddIt = false;
          if (!ShoppingList.liste[j].repas.contains(r))
            ShoppingList.liste[j].repas.add(r);
        }
      }
      if (weCanAddIt) {
        ShoppingList.liste
            .add(new IngredientListeCourse(r.listIngredient[i], r));
      }

      weCanAddIt = true;
    }
  }

  static void resetListe() {
    ShoppingList.liste.removeRange(0, ShoppingList.liste.length);
  }

  static String afficher() {
    String a = '';
    for (int i = 0; i < ShoppingList.liste.length; i++) {
      a += ShoppingList.liste[i].i.name;
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
      children: ShoppingList.liste
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
