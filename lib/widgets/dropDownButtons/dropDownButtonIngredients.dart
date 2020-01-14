import 'package:flutter/material.dart';

import 'package:bonap/ingredients.dart';

class DropDownButtonIngredients extends StatefulWidget {
  final State s;
  DropDownButtonIngredients(this.s);

   @override
  _DropDownButtonIngredientsState createState() => _DropDownButtonIngredientsState();
}

class _DropDownButtonIngredientsState extends State<DropDownButtonIngredients> {


  String _value;
  List<String> _categories = new List<String>();

  @override
  void initState() {
    super.initState();
    _categories.addAll(["Viande",
      "Légume",
      "Poisson",
      "Féculent",
      "Produit Laitier",
      "Autre"]);
    switch (Ingredient.newCat) {
      case "Viande":
        _value = _categories.elementAt(0);
        break;
      case "Légume":
        _value = _categories.elementAt(1);
        break;
      case "Poisson":
        _value = _categories.elementAt(2);
        break;
      case "Féculent":
        _value = _categories.elementAt(3);
        break;
      case "Produit Laitier":
        _value = _categories.elementAt(4);
        break;
      case "Autre":
        _value = _categories.elementAt(5);
        break;

    }

    Ingredient.newCat = _value;
  }

  void _onChanged(String value) {
    setState(() {
      _value = value;
      Ingredient.newCat = value;
      this.widget.s.setState( () {});

    });
  }

  @override
  Widget build(BuildContext context) {
    return new DropdownButton(
      value: _value,
      items: _categories.map((String value) {
        return new DropdownMenuItem(
            value: value,
            child: new Row(children: <Widget>[
              Text('$value')
            ]));
      }).toList(),
      onChanged: (String value) {
        _onChanged(value);

      },
    );
  }
}
