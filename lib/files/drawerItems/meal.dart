import 'package:bonap/files/data/dataStorage.dart';
import 'package:flutter/material.dart';
import 'package:bonap/files/tools.dart';

import 'ingredients.dart';

class Meal {
  String name = '';
  List<Ingredient> listIngredient = new List<Ingredient>();
  bool fav;

  static List<Meal> listMeal = new List<Meal>();
  static String filter = "";
  static bool searching = false;

  Meal(String name, List<Ingredient> listIngredient) {
    this.name = name;
    this.listIngredient = listIngredient;
    this.fav = false;
  }

  String listIngredientToString() {
    // Supprime les ingredients s'ils n'existent plus
//    for (var i = 0; i < listIngredient.length; i++) {
//      if (Ingredient.ingredients.contains(listIngredient[i]) == false) {
//        listIngredient.remove(listIngredient[i]);
//      }
//    }
    String str = '';
    listIngredient.forEach((a) => str += ' ' + a.name);
    return str;
  }

  // Sauvegarde et chargement
  Meal.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        fav = json['fav'],
        listIngredient = createList(json['ingredients']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'fav': fav,
        'ingredients': listIngredient,
      };

  static List<Ingredient> createList(List<dynamic> s) {
    List<Ingredient> L = new List<Ingredient>();
    for (int i = 0; i < s.length; i++) {
      L.add(new Ingredient(s[i]['name'],
          Category.values.firstWhere((e) => e.toString() == s[i]['category'])));
    }
    return L;
  }
}

class RepasPage extends StatefulWidget {
  @override
  _RepasPageState createState() => new _RepasPageState();
}

class _RepasPageState extends State<RepasPage> {
  bool checkboxValueIngr = false;
  List<Ingredient> allIngr = Ingredient.listIngredients;
  List<Ingredient> selectedIngr = [];
  popUpSort _selectionSort;

  ListView disMeal = new ListView();

  @override
  void initState() {
    Meal.filter = "";
    Meal.searching = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Repas'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              tooltip: "Chercher un repas ..",
              onPressed: () {
                setState(() {
                  Meal.searching = !Meal.searching;
                  if (!Meal.searching) Meal.filter = "";
                });
              },
            ),
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
                  value: popUpSort.favorite,
                  child: Text('Favoris'),
                ),
              ],
            ),
            IconButton(
                icon: Icon(Icons.delete),
                tooltip: "Supprimer tous les repas",
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return _ResetDialog(this);
                      });
                }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Color.fromRGBO(0, 191, 255, 1),
          tooltip: "Ajouter un repas",
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return _MyDialog(
                      rps: this,
                      ingr: allIngr,
                      selectedIngr: [],
                      onSelectedIngrChanged: (ingr) {
                        selectedIngr = ingr;
                      });
                });
          },
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Meal.searching ? searchBar() : new Row(),
              Expanded(
                child: displayMeal(),
              )
            ],
          ),
        ));
  }

  ListView displayMeal() {
    switch (this._selectionSort) {
      case popUpSort.alpha:
        Meal.listMeal
            .sort((a, b) => a.name.toString().compareTo(b.name.toString()));
        break;
      case popUpSort.favorite:
        Meal.listMeal
            .sort((b, a) => a.fav.toString().compareTo(b.fav.toString()));
        break;
      default:
        break;
    }
    List<Meal> newList = new List();
    var listMeal = Meal.listMeal;
    if (Meal.filter != "") {
      for (Meal m in Meal.listMeal) {
        if (m.name.contains(Meal.filter)) {
          newList.add(m);
        }
      }
    } else
      newList = listMeal;

    return ListView(
      shrinkWrap: true,
      children: newList
          .map(
            (data) => new Container(
              child: ListTile(
                title: Text(data.name),
                subtitle: Text(data.listIngredientToString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                        icon: data.fav
                            ? Icon(Icons.star)
                            : Icon(Icons.star_border),
                        onPressed: () {
                          setState(() {
                            data.fav = data.fav ? false : true;
                            DataStorage.saveRepas();
                          });
                        }),
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return _MyDialogEdit(
                                  r: data,
                                  rps: this,
                                  ingr: allIngr,
                                  selectedIngr: [],
                                  onSelectedIngrChanged: (ingr) {
                                    selectedIngr = ingr;
                                  });
                            });
                      },
                    ),
                  ],
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return _MyDialogEdit(
                            r: data,
                            rps: this,
                            ingr: allIngr,
                            selectedIngr: [],
                            onSelectedIngrChanged: (ingr) {
                              selectedIngr = ingr;
                            });
                      });
                },
              ),
            ),
          )
          .toList(),
    );
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
                Meal.filter = value;
              });
            },
          ),
        ),
      ],
    );
  }
}

class _MyDialogEdit extends StatefulWidget {
  _MyDialogEdit({
    this.r,
    this.rps,
    this.onSelectedIngrChanged,
    this.ingr,
    this.selectedIngr,
  });

  final Meal r;
  final _RepasPageState rps;
  final ValueChanged<List<Ingredient>> onSelectedIngrChanged;
  final List<Ingredient> ingr;
  final List<Ingredient> selectedIngr;

  @override
  _MyDialogEditState createState() => _MyDialogEditState();
}

class _MyDialogEditState extends State<_MyDialogEdit> {
  List<Ingredient> _tempSelectedIngr = [];
  String newMealName = '';
  bool customName = true;
  bool weCanEditIt = true;
  bool typing = false;

  @override
  void initState() {
    for (Ingredient i in widget.r.listIngredient) {
      widget.selectedIngr.add(i);
      _tempSelectedIngr.add(i);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    typing = MediaQuery.of(context).viewInsets.bottom > 0 ? true : false;
    return AlertDialog(
      title: Text(
        'Modifier ' + widget.r.name,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              child: TextField(
            autofocus: false,
            decoration: new InputDecoration(
                labelText: 'Nom du repas', hintText: newMealName),
            onChanged: (value) {
              customName = true;
              newMealName = value;
              if (newMealName == '') customName = false;
            },
          )),
          Container(
            width: Constant.width * 0.8,
            height: typing ? Constant.width * 0.4 : Constant.height * 0.7,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.ingr.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ingrName = Ingredient.listIngredients[index];

                        return Container(
                          child: CheckboxListTile(
                              title: Row(
                                children: <Widget>[
                                  Ingredient.catIcon(ingrName.cat),
                                  Text('    '),
                                  Text(RenderingText.nameWithoutTheEnd(ingrName.name, 4)),
                                ],
                              ),
                              value: isIn(_tempSelectedIngr, ingrName),
                              onChanged: (bool value) {
                                if (value) {
                                  if (!isIn(_tempSelectedIngr, ingrName)) {
                                    setState(() {
                                      _tempSelectedIngr.add(ingrName);
                                    });
                                  }
                                } else {
                                  if (isIn(_tempSelectedIngr, ingrName)) {
                                    setState(() {
                                      _tempSelectedIngr.removeWhere(
                                          (Ingredient ingr) =>
                                              ingr.name == ingrName.name);
                                    });
                                  }
                                }

                                widget.onSelectedIngrChanged(_tempSelectedIngr);

                                if (!customName)
                                  newMealName = _tempSelectedIngr.toString();
                              }),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            if (!widget.r.fav) {
              Meal.listMeal.remove(widget.r);
              widget.rps.setState(() {});
              DataStorage.saveRepas();
              Navigator.pop(context);
            }
          },
        ),
        FlatButton(
          onPressed: () {
            if (newMealName != '') {
              for (int i = 0; i < Meal.listMeal.length; i++) {
                if (weCanEditIt) {
                  if (Meal.listMeal[i].name == newMealName) {
                    weCanEditIt = false;
                  }
                }
              }
              if (weCanEditIt) widget.r.name = newMealName;
            }

            widget.r.listIngredient = _tempSelectedIngr;

            widget.rps
                .setState(() => widget.rps.disMeal = widget.rps.displayMeal());
            DataStorage.saveRepas();
            Navigator.pop(context);
          },
          child: Text('Ok'),
        ),
      ],
    );
  }

  bool isIn(List<Ingredient> L, Ingredient I) {
    var b = false;
    for (Ingredient A in L) {
      b = ((A.name == I.name) && (A.cat == I.cat));
      if (b) return true;
    }
    return false;
  }
}

class _MyDialog extends StatefulWidget {
  _MyDialog({
    this.ingr,
    this.selectedIngr,
    this.onSelectedIngrChanged,
    this.rps,
  });

  final List<Ingredient> ingr;
  final List<Ingredient> selectedIngr;
  final ValueChanged<List<Ingredient>> onSelectedIngrChanged;
  final _RepasPageState rps;

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<_MyDialog> {
  List<Ingredient> _tempSelectedIngr = [];
  String newRepasName = '';
  bool customName = false;
  bool weCanAddIt = true;
  bool typing = false;

  @override
  void initState() {
    _tempSelectedIngr = widget.selectedIngr;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    typing = MediaQuery.of(context).viewInsets.bottom > 0 ? true : false;
    return AlertDialog(
      title: Ingredient.listIngredients.length == 0
          ? Text('Vous allez trop vite !')
          : Text('Ajouter un repas'),
      content: Ingredient.listIngredients.length == 0
          ? Text("Commencez par ajouter des ingrédients !")
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    child: TextField(
                  autofocus: false,
                  decoration: new InputDecoration(
                      labelText: 'Nom du repas', hintText: newRepasName),
                  onChanged: (value) {
                    customName = true;
                    newRepasName = value;
                    if (newRepasName == '') customName = false;
                  },
                )),
                Container(
                  width: Constant.width * 0.8,
                  height: typing
                      ? Constant.width * 0.4
                      : Constant.width * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                            itemCount: widget.ingr.length,
                            itemBuilder: (BuildContext context, int index) {
                              final ingrName = widget.ingr[index];
                              return Container(
                                child: CheckboxListTile(
                                    title: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 12),
                                          child: Row(
                                            children: <Widget>[
                                              Ingredient.catIcon(ingrName.cat),
                                            ],
                                          ),
                                        ),
                                        Text(RenderingText.nameWithoutTheEnd(ingrName.name, 4)),
                                      ],
                                    ),
                                    value: _tempSelectedIngr.contains(ingrName),
                                    onChanged: (bool value) {
                                      if (value) {
                                        if (!_tempSelectedIngr
                                            .contains(ingrName)) {
                                          setState(() {
                                            _tempSelectedIngr.add(ingrName);
                                          });
                                        }
                                      } else {
                                        if (_tempSelectedIngr
                                            .contains(ingrName)) {
                                          setState(() {
                                            _tempSelectedIngr.removeWhere(
                                                (Ingredient ingr) =>
                                                    ingr == ingrName);
                                          });
                                        }
                                      }

                                      widget.onSelectedIngrChanged(
                                          _tempSelectedIngr);

                                      if (!customName)
                                        newRepasName =
                                            _tempSelectedIngr.toString();
                                    }),
                              );
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Ingredient.listIngredients.length > 0 ?
            Padding(
              padding: const EdgeInsets.only(right: 20 ),
              child: FlatButton(
                child: Text('Modifier des ingrédients'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => IngredientsPage()));
                },
              ),
            ) : Container(),
            FlatButton(
              onPressed: Ingredient.listIngredients.length == 0
                  ? () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  IngredientsPage()));
                    }
                  : () {
                      if (newRepasName != '') {
                        for (int i = 0; i < Meal.listMeal.length; i++) {
                          if (weCanAddIt) {
                            if (Meal.listMeal[i].name == newRepasName) {
                              weCanAddIt = false;
                            }
                          }
                        }
                      }
                      if (newRepasName == '') weCanAddIt = false;
                      if (weCanAddIt)
                        Meal.listMeal
                            .add(Meal(newRepasName, _tempSelectedIngr));
                      widget.rps.setState(
                          () => widget.rps.disMeal = widget.rps.displayMeal());
                      DataStorage.saveRepas();
                      Navigator.pop(context);
                    },
              child: Text('Ok'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ResetDialog extends StatefulWidget {
  final _RepasPageState rps;

  _ResetDialog(this.rps);

  @override
  _ResetDialogState createState() => _ResetDialogState();
}

class _ResetDialogState extends State<_ResetDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Réinitialisation des repas?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Non'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Oui'),
          onPressed: () {
            Meal.listMeal.removeRange(0, Meal.listMeal.length);
            DataStorage.saveRepas();
            Navigator.of(context).pop();
            widget.rps
                .setState(() => widget.rps.disMeal = widget.rps.displayMeal());
          },
        ),
      ],
    );
  }
}

// TO DO LIST
/*
* Filtrer les repas
* Compteur de nombre de fois ou on la pris
* Menu edit
* Securite noms, existe deja etc
* */
