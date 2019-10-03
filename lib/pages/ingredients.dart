import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum Categorie { viande, poisson, legume, fruit, feculent, autre }

class Ingredient {
  String nom;
  Categorie cat;
  static List<Ingredient> ingredients = new List<Ingredient>();

  Ingredient(this.nom, this.cat);
}

class IngredientsPage extends StatefulWidget {
  @override
  _IngredientsPageState createState() => new _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  String newIngr = '';
  String newCat = 'Autre';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Ingrédients'),
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            children: Ingredient.ingredients
                .map((data) => ListTile(
                    leading: _catIcon(data.cat),
                    title: Text(data.nom)))

                .toList(),
          ),
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

  void _ajouterIngredient() {
    final List<String> _dropdownValues = [
      "Viande",
      "Légume",
      "Poisson",
      "Féculent",
      "Autre"
    ];
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Ajouter un ingrédient'),
          content: new Row(
            children: <Widget>[
              Container(
                child: new DropdownButton(
                  items: _dropdownValues
                      .map((value) => DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (String value) {
                    newCat = value;
                  },
                  isExpanded: false,
                  hint: Text(newCat),

                ),
              ),
              Expanded(
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
                    switch (newCat){

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
                      case ("Autre"):
                        Ingredient.ingredients
                            .add(new Ingredient(newIngr, Categorie.autre));
                        break;
                      default:
                        break;
                    }

                }

                Navigator.of(context).pop();
                print(Ingredient.ingredients[0].nom);
              },
            ),
          ],
        );
      },
    );
  }

  Icon _catIcon(Categorie c) {

    switch (c)
    {
      case (Categorie.autre):
        return Icon(Icons.devices_other);
        break;
      case (Categorie.feculent):
        return Icon(Icons.add);
        break;
      case (Categorie.viande):
        return Icon(Icons.mail);
        break;
      case (Categorie.poisson):
        return Icon(Icons.fiber_dvr);
        break;
      case (Categorie.fruit):
        return Icon(Icons.apps);
        break;
      case (Categorie.legume):
        return Icon(Icons.language);
        break;
      default:
        return Icon(Icons.cake);
        break;


    }
  }
}
