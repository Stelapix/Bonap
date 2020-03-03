import 'package:bonap/files/drawerItems/ingredients.dart';
import 'package:bonap/files/drawerItems/meal.dart';
import 'package:bonap/files/widgets/dayMenu.dart';
import 'package:flutter/material.dart';

class ShoppingList {
  static List<IngredientShoppingList> liste =
      new List<IngredientShoppingList>();

  static void addMealToList(Meal m) {
    bool weCanAddIt = true;
    for (int i = 0; i < m.listIngredient.length; i++) {
      for (int j = 0; j < liste.length; j++) {
        if (liste[j].i.name == m.listIngredient[i].name) {
          weCanAddIt = false;
          liste[j].listMeal.add(m);
        }
      }
      if (weCanAddIt) {
        liste.add(new IngredientShoppingList(m.listIngredient[i], m));
      }

      weCanAddIt = true;
    }
  }
}

class IngredientShoppingList {
  Ingredient i;
  List<Meal> listMeal = new List<Meal>();

  IngredientShoppingList(Ingredient i, Meal m) {
    this.i = i;
    this.listMeal.add(m);
  }

  String displayMeals() {
    String a = '';
    for (int b = 0; b < listMeal.length; b++) {
      a += (listMeal[b].name);
      if (b != listMeal.length-1) a += '\n';
    }
    return a;
  }
}

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => new _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Liste de Course'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.ac_unit),
            onPressed: () {
              setState(() {
                ShoppingList.liste = new List<IngredientShoppingList>();
                for (Day d in Day.listDay) {
                  if (d != null) {
                    for (Meal m in d.listMeal) {
                      if (m != null) ShoppingList.addMealToList(m);
                    }
                  }
                }
              });
            },
          )
        ],
      ),
      body: Container(
        child: display(),
      ),
    );
  }

  ListView display() {
    return ListView(
      shrinkWrap: true,
      children: ShoppingList.liste
          .map(
            (data) => new Container(
              child: ExpansionTile(
                  title: Text(data.i.name),
                  leading: data.i.icon,
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        //ListeCourse.liste.remove(data.i);
                      });
                    },
                  ),
                  children: <Widget>[
                    Text(
                      data.displayMeals(),
                    ),
                  ]),
            ),
          )
          .toList(),
    );
  }
}
