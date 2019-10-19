import 'package:flutter/material.dart';
import 'ingredients.dart';

class Repas {
  String nom = '';
  List<Ingredient> listIngredient = new List<Ingredient>();

  static List<Repas> listRepas = new List<Repas>();

  Repas(this.nom, this.listIngredient);

  String listIngredientToString() {
    String str = '';
    listIngredient.forEach((a) => str += ' ' + a.nom);
    return str;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Repas'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return _MyDialog(
                      ingr: allIngr,
                      selectedIngr: selectedIngr,
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
                child: ListView(
                  shrinkWrap: true,
                  children: Repas.listRepas
                      .map(
                        (data) => new Container(
                          child: ListTile(
                            title: Text(data.nom),
                            subtitle: Text(data.listIngredientToString()),
                            trailing: IconButton(
                              icon: Icon(Icons.more_vert),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          ),
        ));
  }
}

class _MyDialog extends StatefulWidget {
  _MyDialog({
    this.ingr,
    this.selectedIngr,
    this.onSelectedIngrChanged,
  });

  final List<Ingredient> ingr;
  final List<Ingredient> selectedIngr;
  final ValueChanged<List<Ingredient>> onSelectedIngrChanged;

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
                  if (weCanAddIt) Repas.listRepas.add(Repas(newRepasName, _tempSelectedIngr));
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
