import 'package:flutter/material.dart';

import 'package:bonap/ingredients.dart';

class DropDownButtonIngredients extends StatefulWidget {
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
    _value = _categories.elementAt(0);
    Ingredient.newCat = _value;
  }

  void _onChanged(String value) {
    setState(() {
      _value = value;
      Ingredient.newCat = value;
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
