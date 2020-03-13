import 'package:bonap/files/drawerItems/ingredients.dart';
import 'package:bonap/files/drawerItems/meal.dart';
import 'package:bonap/files/widgets/dayMenu.dart';
import 'package:flutter/material.dart';
import 'package:bonap/files/tools.dart';
import 'package:bonap/files/data/dataStorage.dart';

class ShoppingList {
  static List<IngredientShoppingList> liste =
      new List<IngredientShoppingList>();

  static String filter;
  static bool searching;

  static void addMealToList(Meal m) {
    bool weCanAddIt = true;
    for (int i = 0; i < m.listIngredient.length; i++) {
      for (int j = 0; j < liste.length; j++) {
        if (liste[j].i.name == m.listIngredient[i].name) {
          weCanAddIt = false;
          liste[j].listMeal.add(m);
          liste[j].amount++;
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
  int amount;

  IngredientShoppingList(Ingredient i, Meal m) {
    this.i = i;
    this.listMeal.add(m);
    this.amount = 1;
  }

  String displayMeals() {
    String a = '';
    if (this.listMeal[0] == null) return a;
    for (int b = 0; b < listMeal.length; b++) {
      a += (listMeal[b].name);
      if (b != listMeal.length - 1) a += '\n';
    }
    return a;
  }

  // Sauvegarde et chargement
  IngredientShoppingList.fromJson(Map<String, dynamic> json)
      : amount = json['amount'],
        i = Ingredient.fromJson(json['i']),
        listMeal = createList(json['listMeal']);

  Map<String, dynamic> toJson() => {
        'i': i,
        'amount': amount,
        'listMeal': listMeal,
      };

  static List<Meal> createList(List<dynamic> s) {
    List<Meal> L = new List<Meal>();
    if (s[0] != null) {


      for (int i = 0; i < s.length; i++) {
        L.add(Meal.fromJson(s[i]));
      }

    }
    else {
      L.add(null);
    }
    
    

    return L;
  }
}

class ShoppingListPage extends StatefulWidget {
  @override
  ShoppingListPageState createState() => new ShoppingListPageState();
}

class ShoppingListPageState extends State<ShoppingListPage> {
  popUpSort _selectionSort;

  @override
  void initState() {
    super.initState();
    ShoppingList.filter = "";
    ShoppingList.searching = false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Liste de Course'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                tooltip: "Chercher un élément ..",
                onPressed: () {
                  setState(() {
                    ShoppingList.searching = !ShoppingList.searching;
                    if (!ShoppingList.searching) ShoppingList.filter = "";
                  });
                }),
            PopupMenuButton<popUpSort>(
              onSelected: (popUpSort result) {
                setState(() {
                  _selectionSort = result;
                });
              },
              tooltip: "Trier par ..",
              icon: Icon(Icons.sort),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<popUpSort>>[
                const PopupMenuItem<popUpSort>(
                  value: popUpSort.alpha,
                  child: Text('Ordre alphabétique'),
                ),
                const PopupMenuItem<popUpSort>(
                  value: popUpSort.category,
                  child: Text('Catégories'),
                ),
                const PopupMenuItem<popUpSort>(
                  value: popUpSort.favorite,
                  child: Text('Favoris'),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.file_download),
              tooltip: 'Importer depuis le menu',
              onPressed: () {
                setState(() {
                  ShoppingList.liste = new List<IngredientShoppingList>();
                  for (Day d in Weeks.week0) {
                    if (d != null) {
                      for (Meal m in d.listMeal) {
                        if (m != null) ShoppingList.addMealToList(m);
                      }
                    }
                  }
                  DataStorage.saveShopping();
                });
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              ShoppingList.searching ? searchBar() : new Row(),
              Expanded(child: display(),)

          ],)
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AddDialog(
                    slps: this,
                  );
                });
          },
          backgroundColor: Color.fromRGBO(0, 191, 255, 1),
          child: Icon(Icons.add),
          tooltip: "Ajouter un élément",
        ));
  }

  Row searchBar() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            autofocus: true,
            decoration: new InputDecoration(
              labelText: " Chercher ...",
            ),
            onChanged: (value) {
              setState(() {
                ShoppingList.filter = value;
              });
            },
          ),
        ),
      ],
    );
  }

  ListView display() {
    switch (this._selectionSort) {
      case popUpSort.alpha:
        ShoppingList.liste
            .sort((a, b) => a.i.name.toString().compareTo(b.i.name.toString()));
        break;
      case popUpSort.category:
        ShoppingList.liste
            .sort((a, b) => a.i.cat.toString().compareTo(b.i.cat.toString()));
        break;
      case popUpSort.favorite:
        ShoppingList.liste
            .sort((b, a) => a.i.fav.toString().compareTo(b.i.fav.toString()));
        break;
      default:
        break;
    }

    List<IngredientShoppingList> newList = new List();

      for (IngredientShoppingList i in ShoppingList.liste) {
        if (i.i.name.contains(ShoppingList.filter)) {
          newList.add(i);
          if (LoginTools.vege) {
            if (i.i.cat == Category.meat || i.i.cat == Category.salami || i.i.cat == Category.fish) {
              newList.remove(i);
            }
          }
          
        }
      }


    return ListView(
      shrinkWrap: true,
      children: newList
          .map(
            (data) => new Container(
              child: ExpansionTile(
                  title:
                      Text(data.i.name + ' (' + (data.amount.toString()) + ')'),
                  leading: data.i.icon,
                  trailing: IconButton(
                    icon: Icon(Icons.done),
                    tooltip: 'Supprimer cet élément',
                    onPressed: () {
                      setState(() {
                        ShoppingList.liste.remove(data);
                        DataStorage.saveShopping();
                      });
                    },
                  ),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              data.amount++;
                              DataStorage.saveShopping();
                            });
                          },
                          tooltip: "Ajouter 1",
                        ),
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (data.amount > 1) data.amount--;
                              DataStorage.saveShopping();
                            });
                          },
                          tooltip: "Retirer 1",
                        ),
                      ],
                    ),
                    data.listMeal[0] != null
                        ? Column(
                            children: <Widget>[
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Compris dans :',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                data.displayMeals(),
                              ),
                            ],
                          )
                        : Column(),
                  ]),
            ),
          )
          .toList(),
    );
  }
}

class AddDialog extends StatefulWidget {
  AddDialog({
    this.slps,
  });

  final ShoppingListPageState slps;

  @override
  AddDialogState createState() => AddDialogState();
}

class AddDialogState extends State<AddDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool alreadyIn = false;
    return AlertDialog(
      title: Text('Ajouter un ingrédient'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: Constant.width * 0.8,
            height: Constant.height * 0.6,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: Ingredient.listIngredients.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(RenderingText.nameWithoutTheEnd(
                            Ingredient.listIngredients[index].name, 2.8)),
                        leading: Ingredient.listIngredients[index].icon,
                        onTap: () {
                          widget.slps.setState(() {
                            // Ingredient deja present, on augmente le compteur
                            for (IngredientShoppingList isl
                                in ShoppingList.liste) {
                              if (isl.i.name ==
                                  Ingredient.listIngredients[index].name) {
                                alreadyIn = true;
                              }
                            }
                            if (alreadyIn) {
                              print("Incremente");
                              for (IngredientShoppingList i
                                  in ShoppingList.liste) {
                                if (i.i.name ==
                                    Ingredient.listIngredients[index].name) {
                                  i.amount++;
                                }
                              }
                            }
                            // Sinon on l'ajoute
                            else {
                              print("Ajout");
                              ShoppingList.liste.add(new IngredientShoppingList(
                                  Ingredient.listIngredients[index], null));
                            }
                          });
                          DataStorage.saveShopping();
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ListView ingredients() {
    return ListView(
      shrinkWrap: true,
      children: Ingredient.listIngredients
          .map(
            (data) => new Container(
              child: ListTile(
                title: Text(data.name),
                onTap: () {},
              ),
            ),
          )
          .toList(),
    );
  }
}
