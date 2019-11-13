import 'dart:convert';

import 'package:flutter/material.dart';
import 'ingredients.dart';
import 'widgets/dataStorage.dart';

class Repas {
  String nom = '';
  List<Ingredient> listIngredient = new List<Ingredient>();

  static List<Repas> listRepas = new List<Repas>();

  Repas(this.nom, this.listIngredient);


  String listIngredientToString() {
    // Supprime les ingredients s'ils n'existent plus
//    for (var i = 0; i < listIngredient.length; i++) {
//      if (Ingredient.ingredients.contains(listIngredient[i]) == false) {
//        listIngredient.remove(listIngredient[i]);
//      }
//    }
    String str = '';
    listIngredient.forEach((a) => str += ' ' + a.nom);
    return str;
  }

  // Sauvegarde et chargement
  Repas.fromJson(Map<String, dynamic> json) :
        nom = json['nom'],
        listIngredient = createList(json['ingredients']);



  Map<String, dynamic> toJson() => {
    'nom': nom,
    'ingredients': listIngredient,

  };

  static List<Ingredient> createList(List<dynamic> s) {
    List<Ingredient> L = new List<Ingredient>();
    for (int i = 0; i < s.length; i++) {
      L.add(new Ingredient(s[i]['nom'], Categorie.values.firstWhere((e) => e.toString() == s[i]['categorie'])));
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
  List<Ingredient> allIngr = Ingredient.ingredients;
  List<Ingredient> selectedIngr = [];

  ListView affRepas = new ListView();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: new AppBar(
          title: new Text('Repas'),
          actions: <Widget>[
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
              Expanded(
                child: displayRepas(),
              )
            ],
          ),
        ));
  }

  ListView displayRepas() {
    return ListView(
      shrinkWrap: true,
      children: Repas.listRepas
          .map(
            (data) => new Container(
          child: ListTile(
            title: Text(data.nom),
            subtitle: Text(data.listIngredientToString()),
            trailing: IconButton(
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
                          }
                      );
                    });
              },
            ),
          ),
        ),
      )
          .toList(),
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

  final Repas r;
  final _RepasPageState rps;
  final ValueChanged<List<Ingredient>> onSelectedIngrChanged;
  final List<Ingredient> ingr;
  final List<Ingredient> selectedIngr;



  @override
  _MyDialogEditState createState() => _MyDialogEditState();
}

class _MyDialogEditState extends State<_MyDialogEdit> {
  List<Ingredient> _tempSelectedIngr = [];
  String newRepasName = '';
  bool customName = false;
  bool weCanEditIt = true;

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
    return Dialog(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Modifier ' + widget.r.nom,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

              RaisedButton(
                onPressed: () {
                  if (newRepasName != '') {
                    for (int i = 0; i < Repas.listRepas.length; i++) {
                      if (weCanEditIt) {
                        if (Repas.listRepas[i].nom == newRepasName) {
                          weCanEditIt = false;
                        }
                      }
                    }
                  }

                  if (weCanEditIt) widget.r.nom = newRepasName;
                  widget.r.listIngredient = _tempSelectedIngr;
                  //print(_tempSelectedIngr);

                  widget.rps.setState(() => widget.rps.affRepas = widget.rps.displayRepas());
                  DataStorage.saveRepas();
                  Navigator.pop(context);
                },
                child: Text('Ok'),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                  width: 230,
                  constraints: BoxConstraints(minWidth: 230, minHeight: 0),
                  child: TextField(
                    autofocus: false,
                    decoration: new InputDecoration(
                        labelText: 'Nom du repas', hintText: newRepasName),
                    onChanged: (value) {
                      customName = true;
                      newRepasName = value;
                      if (newRepasName == '') customName = false;
                    },
                  ))
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: widget.ingr.length,
                itemBuilder: (BuildContext context, int index) {
                  final ingrName = Ingredient.ingredients[index];

                  return Container(
                    child: CheckboxListTile(
                        title: Row(
                          children: <Widget>[
                            Ingredient.catIcon(ingrName.cat),
                            Text('    '),
                            Text(ingrName.nameWithoutTheEnd()),
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
                                        (Ingredient ingr) => ingr.nom == ingrName.nom);
                              });
                            }
                          }

                          widget.onSelectedIngrChanged(_tempSelectedIngr);

                          if (!customName)
                            newRepasName = _tempSelectedIngr.toString();
                        }),
                  );
                }),
          ),
        ],
      ),
    );
  }

  bool isIn(List<Ingredient> L, Ingredient I) {
    var b = false;
    for (Ingredient A in L) {
      b = ((A.nom == I.nom) && (A.cat == I.cat));
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

  @override
  void initState() {
    _tempSelectedIngr = widget.selectedIngr;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '   Création Repas',
                style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                onPressed: () {
                  if (newRepasName != '') {
                    for (int i = 0; i < Repas.listRepas.length; i++) {
                      if (weCanAddIt) {
                        if (Repas.listRepas[i].nom == newRepasName) {
                          weCanAddIt = false;
                        }
                      }
                    }
                  }
                  if (weCanAddIt)
                    Repas.listRepas.add(Repas(newRepasName, _tempSelectedIngr));
                  widget.rps.setState(() => widget.rps.affRepas = widget.rps.displayRepas());
                  DataStorage.saveRepas();
                  Navigator.pop(context);
                },
                child: Text('Ok'),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                  width: 230,
                  constraints: BoxConstraints(minWidth: 230, minHeight: 0),
                  child: TextField(
                    autofocus: false,
                    decoration: new InputDecoration(
                        labelText: 'Nom du repas', hintText: newRepasName),
                    onChanged: (value) {
                      customName = true;
                      newRepasName = value;
                      if (newRepasName == '') customName = false;
                    },
                  ))
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: widget.ingr.length,
                itemBuilder: (BuildContext context, int index) {
                  final ingrName = widget.ingr[index];
                  return Container(
                    child: CheckboxListTile(
                        title: Row(
                          children: <Widget>[
                            Ingredient.catIcon(ingrName.cat),
                            Text('    '),
                            Text(ingrName.nameWithoutTheEnd()),
                          ],
                        ),
                        value: _tempSelectedIngr.contains(ingrName),
                        onChanged: (bool value) {
                          if (value) {
                            if (!_tempSelectedIngr.contains(ingrName)) {
                              setState(() {
                                _tempSelectedIngr.add(ingrName);
                              });
                            }
                          } else {
                            if (_tempSelectedIngr.contains(ingrName)) {
                              setState(() {
                                _tempSelectedIngr.removeWhere(
                                        (Ingredient ingr) => ingr == ingrName);
                              });
                            }
                          }

                          widget.onSelectedIngrChanged(_tempSelectedIngr);

                          if (!customName)
                            newRepasName = _tempSelectedIngr.toString();
                        }),
                  );
                }),
          ),
        ],
      ),
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
            Repas.listRepas
                .removeRange(0, Repas.listRepas.length);
            DataStorage.saveRepas();
            Navigator.of(context).pop();
            widget.rps.setState(() =>
            widget.rps.affRepas = widget.rps.displayRepas());
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
