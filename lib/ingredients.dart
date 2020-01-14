import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'custom/custom_icons.dart';
import 'widgets/dropDownButtons/dropDownButtonIngredients.dart';
import 'widgets/dataStorage.dart';

enum Category { meal, fish, vegetable, fruit, starchy, milk, other }
//Starchy is feculent
enum popUpSort { alpha, category, favorite }

class Ingredient {
  String name;
  Category cat;
  Icon icon;
  bool fav;
  static String newCat;
  static List<Ingredient> listIngredients = new List<Ingredient>();
  static bool searching = false;
  static String filter = "";

  Ingredient(String name, Category cat) {
    this.name = name;
    this.cat = cat;
    this.icon = catIcon(this.cat);
    this.fav = false;
  }

  @override
  String toString() {
    return this.name;
  }

  String nameWithoutTheEnd() {
    int max = 25;
    if (this.name.length > max)
      return this.name.substring(0, max) + '...';
    else
      return this.name;
  }

  static Icon catIcon(Category c) {
    switch (c) {
      case (Category.other):
        return Icon(Custom.cereals);
        break;
      case (Category.starchy):
        return Icon(Custom.baguette);
        break;
      case (Category.meal):
        return Icon(Custom.meat);
        break;
      case (Category.fish):
        return Icon(Custom.fish);
        break;
      case (Category.fruit):
        return Icon(Custom.basket);
        break;
      case (Category.vegetable):
        return Icon(Custom.carrot);
        break;
      case (Category.milk):
        return Icon(Custom.cheese);
        break;
      default:
        return Icon(Icons.cake);
        break;
    }
  }

  static String catToString(Category c) {
    switch (c) {
      case (Category.starchy):
        return "Féculent";
        break;
      case (Category.meal):
        return "Viande";
        break;
      case (Category.fish):
        return "Poisson";
        break;
      case (Category.fruit):
        return "Fruit";
        break;
      case (Category.vegetable):
        return "Légume";
        break;
      case (Category.milk):
        return "Produit Laitier";
        break;
      default:
        return "Autre";
        break;
    }
  }

  static Category stringToCategory(String s) {
    switch (s) {
      case "Viande":
        return Category.meal;
        break;
      case "Poisson":
        return Category.fish;
        break;
      case "Fruit":
        return Category.fruit;
        break;
      case "Légume":
        return Category.vegetable;
        break;
      case "Féculent":
        return Category.starchy;
        break;
      case "Produit Laitier":
        return Category.milk;
        break;
      default:
        return Category.other;
        break;
    }
  }

  // Sauvegarde et chargement
  Ingredient.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        fav = json['fav'],
        cat =
            Category.values.firstWhere((e) => e.toString() == json['category']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'fav': fav,
        'category': cat.toString(),
      };
}

class IngredientsPage extends StatefulWidget {
  @override
  _IngredientsPageState createState() => new _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  String newIngr = '';
  ListView affIngredients = new ListView();
  popUpSort _selectionSort;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Ingrédients'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                tooltip: "Chercher un ingrédient",
                onPressed: () {
                  setState(() {
                    Ingredient.searching = !Ingredient.searching;
                    if (!Ingredient.searching) Ingredient.filter = "";
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
                icon: Icon(Icons.delete),
                tooltip: "Supprimer tous les ingrédients",
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return _ResetDialog(this);
                      });
                }),
          ],
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            Ingredient.searching ? searchBar() : new Row(),
            Expanded(
              child: displayIngredients(),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Color.fromRGBO(0, 191, 255, 1),
            tooltip: "Ajouter un ingredient",
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return _AddDialog(this);
                  });
            }));
  }

  ListView displayIngredients() {
    switch (this._selectionSort) {
      case popUpSort.alpha:
        Ingredient.listIngredients
            .sort((a, b) => a.name.toString().compareTo(b.name.toString()));
        break;
      case popUpSort.category:
        Ingredient.listIngredients
            .sort((a, b) => a.cat.toString().compareTo(b.cat.toString()));
        break;
      case popUpSort.favorite:
        Ingredient.listIngredients
            .sort((b, a) => a.fav.toString().compareTo(b.fav.toString()));
        break;
      default:
        break;
    }
    List<Ingredient> newList = new List();
    if (Ingredient.filter != "") {
      for (Ingredient i in Ingredient.listIngredients) {
        if (i.name.contains(Ingredient.filter)) {
          newList.add(i);
        }
      }
    }
    else newList = Ingredient.listIngredients;

    return ListView(
      shrinkWrap: true,
      children: newList
          .map(
            (data) => new Container(
              child: ListTile(
                leading: Ingredient.catIcon(data.cat),
                title: Text(data.name),
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
                            DataStorage.saveIngredients();
                          });
                        }),
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return _EditDialog(
                                I: data,
                                ips: this,
                              );
                            });
                      },
                    ),
                  ],
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return _EditDialog(
                          I: data,
                          ips: this,
                        );
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
                Ingredient.filter = value;
              });
            },
          ),
        ),
      ],
    );
  }

  void deleteIngredient(Ingredient I) {
    Ingredient.listIngredients.remove(I);
  }
}

class _AddDialog extends StatefulWidget {
  final _IngredientsPageState ips;

  _AddDialog(this.ips);

  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<_AddDialog> {
  String newIngr = '';
  Icon newIcon;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter un ingrédient'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: DropDownButtonIngredients(this),
              ),
              IconButton(
                icon: Ingredient.catIcon(
                    Ingredient.stringToCategory(Ingredient.newCat)),
                onPressed: () {
                  setState(() {});
                },
              )
            ],
          ),
          Container(
              child: new TextField(
            autofocus: false,
            decoration: new InputDecoration(
                labelText: 'Nom', hintText: 'Frite, Steak, Salade ...'),
            onChanged: (value) {
              newIngr = value;
            },
          )),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            if (newIngr != '') {
              var existe = false;
              for (var o in Ingredient.listIngredients) {
                if (o.name.toUpperCase() == newIngr.toUpperCase())
                  existe = true;
              }
              if (!existe)
                Ingredient.listIngredients.add(new Ingredient(
                    newIngr, Ingredient.stringToCategory(Ingredient.newCat)));
            }
            widget.ips.setState(() =>
                widget.ips.affIngredients = widget.ips.displayIngredients());
            DataStorage.saveIngredients();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class _EditDialog extends StatefulWidget {
  final _IngredientsPageState ips;
  final Ingredient I;

  _EditDialog({
    this.ips,
    this.I,
  });

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  String newIngr = '';

  @override
  void initState() {
    Ingredient.newCat = Ingredient.catToString(widget.I.cat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Modifier ' + widget.I.name),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: DropDownButtonIngredients(this),
              ),
              IconButton(
                icon: Ingredient.catIcon(
                    Ingredient.stringToCategory(Ingredient.newCat)),
                onPressed: () {
                  setState(() {});
                },
              ),
            ],
          ),
          Container(
              child: new TextField(
            autofocus: false,
            decoration:
                new InputDecoration(labelText: 'Nom', hintText: widget.I.name),
            onChanged: (value) {
              newIngr = value;
            },
          )),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            if (newIngr == '') newIngr = widget.I.name;
            print(Ingredient.newCat.toString());
            widget.I.name = newIngr;
            switch (Ingredient.newCat) {
              case ("Viande"):
                widget.I.cat = Category.meal;
                break;
              case ("Légume"):
                widget.I.cat = Category.vegetable;
                break;
              case ("Poisson"):
                widget.I.cat = Category.fish;
                break;
              case ("Féculent"):
                widget.I.cat = Category.starchy;
                break;
              case ("Produit Laitier"):
                widget.I.cat = Category.milk;
                break;
              default:
                widget.I.cat = Category.other;
                break;
            }
            widget.ips.setState(() {});
            DataStorage.saveIngredients();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
            child: Icon(Icons.delete),
            onPressed: () {
              if (widget.I.fav) {
                // Mettre un message ?
              } else {
                Ingredient.listIngredients.remove(widget.I);
                DataStorage.saveIngredients();
                Navigator.of(context).pop();
                widget.ips.setState(() => widget.ips.affIngredients =
                    widget.ips.displayIngredients());
              }
            })
      ],
    );
  }
}

class _ResetDialog extends StatefulWidget {
  final _IngredientsPageState ips;

  _ResetDialog(this.ips);

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
      title: Text('Réinitialisation des ingrédients?'),
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
            Ingredient.listIngredients
                .removeRange(0, Ingredient.listIngredients.length);
            DataStorage.saveIngredients();
            Navigator.of(context).pop();
            widget.ips.setState(() =>
                widget.ips.affIngredients = widget.ips.displayIngredients());
          },
        ),
      ],
    );
  }
}
