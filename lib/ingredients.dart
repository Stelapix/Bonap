import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'custom/custom_icons.dart';

import 'widgets/dropDownButtons/dropDownButtonIngredients.dart';

enum Categorie { viande, poisson, legume, fruit, feculent, laitier, autre }

class Ingredient {
  String nom;
  Categorie cat;
  static String newCat;
  static List<Ingredient> ingredients = new List<Ingredient>();

  Ingredient(this.nom, this.cat);
}

enum popUpMenu { reset }

class IngredientsPage extends StatefulWidget {
  @override
  _IngredientsPageState createState() => new _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  String newIngr = '';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Ingrédients'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _resetIngredients,
          ),
        ],
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: Ingredient.ingredients
                  .map(
                    (data) => new Container(
                      child: ListTile(
                        leading: _catIcon(data.cat),
                        title: Text(data.nom),
                        trailing: IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () => _editIngredient(data),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterIngredient,
        tooltip: 'Ajouter un ingrédient',
        backgroundColor: Color.fromRGBO(0, 191, 255, 1),
        child: Icon(Icons.add),
      ),
    );
  }

  void _deleteIngredient(Ingredient I) {
    Ingredient.ingredients.remove(I);
    Navigator.of(context).pop();
    Scaffold.of(context).showSnackBar(new SnackBar(content: Text("Oups")));
  }

  void _editIngredient(Ingredient I) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Modifier ' + I.nom),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: DropDownButtonIngredients(),
              ),
              Container(
                  child: new TextField(
                autofocus: false,
                decoration:
                    new InputDecoration(labelText: 'Nom', hintText: I.nom),
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
                if (newIngr == '') _deleteIngredient(I);
                I.nom = newIngr;
                switch (Ingredient.newCat) {
                  case ("Viande"):
                    I.cat = Categorie.viande;
                    break;
                  case ("Légume"):
                    I.cat = Categorie.legume;
                    break;
                  case ("Poisson"):
                    I.cat = Categorie.poisson;
                    break;
                  case ("Féculent"):
                    I.cat = Categorie.feculent;
                    break;
                  case ("Produit Laitier"):
                    I.cat = Categorie.laitier;
                    break;
                  default:
                    I.cat = Categorie.autre;
                    break;
                }

                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Icon(Icons.delete),
              onPressed: () => _deleteIngredient(I),
            )
          ],
        );
      },
    );
  }

  void _ajouterIngredient() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Ajouter un ingrédient'),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: DropDownButtonIngredients(),
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
                    if (o.nom.toUpperCase() == newIngr.toUpperCase())
                      existe = true;
                  }
                  if (!existe)
                    switch (Ingredient.newCat) {
                      case ("Viande"):
                        Ingredient.ingredients
                            .add(new Ingredient(newIngr, Categorie.viande));
                        break;
                      case ("Poisson"):
                        Ingredient.ingredients
                            .add(new Ingredient(newIngr, Categorie.poisson));
                        break;
                      case ("Légume"):
                        Ingredient.ingredients
                            .add(new Ingredient(newIngr, Categorie.legume));
                        break;
                      case ("Féculent"):
                        Ingredient.ingredients
                            .add(new Ingredient(newIngr, Categorie.feculent));
                        break;
                      case ("Produit Laitier"):
                        Ingredient.ingredients
                            .add(new Ingredient(newIngr, Categorie.laitier));
                        break;
                      case ("Autre"):
                        Ingredient.ingredients
                            .add(new Ingredient(newIngr, Categorie.autre));
                        break;
                      default:
                        break;
                    }
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetIngredients() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Icon _catIcon(Categorie c) {
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
}
