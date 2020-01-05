import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

import 'custom/custom_icons.dart';

import 'widgets/dropDownButtons/dropDownButtonIngredients.dart';
import 'widgets/dataStorage.dart';

enum Categorie { viande, poisson, legume, fruit, feculent, laitier, autre }

class Ingredient {
  String nom;
  Categorie cat;
  Icon icone;
  bool fav;
  static String newCat;
  static List<Ingredient> ingredients = new List<Ingredient>();

  Ingredient(String nom, Categorie cat) {
    this.nom = nom;
    this.cat = cat;
    this.icone = catIcon(this.cat);
    this.fav = false;
  }

  @override
  String toString() {
    return this.nom;
  }

  String nameWithoutTheEnd() {
    int max = 25;
    if (this.nom.length > max)
      return this.nom.substring(0, max) + '...';
    else
      return this.nom;
  }

  static Icon catIcon(Categorie c) {
    switch (c) {
      case (Categorie.autre):
        return Icon(Custom.cereals);
        break;
      case (Categorie.feculent):
        return Icon(Custom.baguette);
        break;
      case (Categorie.viande):
        return Icon(Custom.meat);
        break;
      case (Categorie.poisson):
        return Icon(Custom.fish);
        break;
      case (Categorie.fruit):
        return Icon(Custom.basket);
        break;
      case (Categorie.legume):
        return Icon(Custom.carrot);
        break;
      case (Categorie.laitier):
        return Icon(Custom.cheese);
        break;
      default:
        return Icon(Icons.cake);
        break;
    }
  }

  static String catToString(Categorie c) {
    switch (c) {
      case (Categorie.feculent):
        return "Féculent";
        break;
      case (Categorie.viande):
        return "Viande";
        break;
      case (Categorie.poisson):
        return "Poisson";
        break;
      case (Categorie.fruit):
        return "Fruit";
        break;
      case (Categorie.legume):
        return "Légume";
        break;
      case (Categorie.laitier):
        return "Produit Laitier";
        break;
      default:
        return "Autre";
        break;
    }
  }

  static Categorie stringToCategorie(String s) {
    switch (s) {
      case "Viande":
        return Categorie.viande;
        break;
      case "Poisson":
        return Categorie.poisson;
        break;
      case "Fruit":
        return Categorie.fruit;
        break;
      case "Légume":
        return Categorie.legume;
        break;
      case "Féculent":
        return Categorie.feculent;
        break;
      case "Produit Laitier":
        return Categorie.laitier;
        break;
      default:
        return Categorie.autre;
        break;
    }
  }

  // Sauvegarde et chargement
  Ingredient.fromJson(Map<String, dynamic> json)
      : nom = json['nom'],
        fav = json['fav'],
        cat = Categorie.values
            .firstWhere((e) => e.toString() == json['categorie']);

  Map<String, dynamic> toJson() => {
        'nom': nom,
        'fav': fav,
        'categorie': cat.toString(),
      };
}

enum popUpSort { alpha, categorie }

class IngredientsPage extends StatefulWidget {
  @override
  _IngredientsPageState createState() => new _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  String newIngr = '';
  ListView affIngredients = new ListView();
  popUpSort _selectionSort;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Ingrédients'),
          actions: <Widget>[
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
                  child: Text('Ordre alphabetique'),
                ),
                const PopupMenuItem<popUpSort>(
                  value: popUpSort.categorie,
                  child: Text('Categories'),
                )
              ],
            ),
            IconButton(
                icon: Icon(Icons.delete),
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
        Ingredient.ingredients
            .sort((a, b) => a.nom.toString().compareTo(b.nom.toString()));
        break;
      case popUpSort.categorie:
        Ingredient.ingredients
            .sort((a, b) => a.cat.toString().compareTo(b.cat.toString()));
        break;
      default:
        break;
    }
    return ListView(
      shrinkWrap: true,
      children: Ingredient.ingredients
          .map(
            (data) => new Container(
              child: ListTile(
                leading: Ingredient.catIcon(data.cat),
                title: Text(data.nom),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: data.fav ? Icon(Icons.star) : Icon(Icons.star_border),
                      onPressed: () {
                        setState(() {
                          data.fav = data.fav ? false : true;
                          DataStorage.saveIngredients();
                        });
                      }
                    ),
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

  void deleteIngredient(Ingredient I) {
    Ingredient.ingredients.remove(I);
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
                icon: Ingredient.catIcon(Ingredient.stringToCategorie(Ingredient.newCat)),
                onPressed: () {setState(() {

                });},
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
              for (var o in Ingredient.ingredients) {
                if (o.nom.toUpperCase() == newIngr.toUpperCase()) existe = true;
              }
              if (!existe)
                Ingredient.ingredients.add(new Ingredient(
                    newIngr, Ingredient.stringToCategorie(Ingredient.newCat)));
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
      title: Text('Modifier ' + widget.I.nom),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: DropDownButtonIngredients(this),
              ),
              IconButton(
                icon: Ingredient.catIcon(Ingredient.stringToCategorie(Ingredient.newCat)),
                onPressed: () {setState(() {

                });},
              ),

            ],
          ),

          Container(
              child: new TextField(
            autofocus: false,
            decoration:
                new InputDecoration(labelText: 'Nom', hintText: widget.I.nom),
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
            if (newIngr == '') newIngr = widget.I.nom;
            print(Ingredient.newCat.toString());
            widget.I.nom = newIngr;
            switch (Ingredient.newCat) {
              case ("Viande"):
                widget.I.cat = Categorie.viande;
                break;
              case ("Légume"):
                widget.I.cat = Categorie.legume;
                break;
              case ("Poisson"):
                widget.I.cat = Categorie.poisson;
                break;
              case ("Féculent"):
                widget.I.cat = Categorie.feculent;
                break;
              case ("Produit Laitier"):
                widget.I.cat = Categorie.laitier;
                break;
              default:
                widget.I.cat = Categorie.autre;
                break;
            }
            widget.ips.setState((){});
            DataStorage.saveIngredients();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
            child: Icon(Icons.delete),
            onPressed: () {
              Ingredient.ingredients.remove(widget.I);
              DataStorage.saveIngredients();
              Navigator.of(context).pop();
              widget.ips.setState(() =>
                  widget.ips.affIngredients = widget.ips.displayIngredients());
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
            Ingredient.ingredients
                .removeRange(0, Ingredient.ingredients.length);
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
