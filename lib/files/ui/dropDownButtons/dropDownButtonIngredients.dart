import 'package:bonap/files/drawerItems/ingredients.dart';
import 'package:bonap/files/tools.dart';
import 'package:flutter/material.dart';

class DropDownButtonIngredients extends StatefulWidget {
  final State s;
  DropDownButtonIngredients(this.s);

  @override
  _DropDownButtonIngredientsState createState() =>
      _DropDownButtonIngredientsState();
}

class _DropDownButtonIngredientsState extends State<DropDownButtonIngredients> {
  String _value;
  List<String> _categories = new List<String>();

  @override
  void initState() {
    super.initState();
    _value = "Viande";
    _categories.addAll(LoginTools.vege ? [
      "Féculent",
      "Légume", 
      "Produit Laitier",
      "Liquide",
      "Autre"
    ] : [
      "Viande",
      "Charcuterie",
      "Poisson",
      "Féculent",
      "Légume", 
      "Produit Laitier",
      "Liquide",
      "Autre"
    ]);
    switch (Ingredient.newCat) {
      case "Viande":
        _value = LoginTools.vege ? "" : _categories.elementAt(0);
        break;
      case "Charcuterie":
        _value = LoginTools.vege ? "" : _categories.elementAt(1);
        break;
      case "Poisson":
        _value = LoginTools.vege ? "" : _categories.elementAt(2);
        break;
      case "Féculent":
        _value = LoginTools.vege ? _categories.elementAt(0) : _categories.elementAt(3);
        break;
      case "Légume":
        _value = LoginTools.vege ? _categories.elementAt(1) : _categories.elementAt(4);
        break;
      case "Produit Laitier":
        _value = LoginTools.vege ? _categories.elementAt(2) : _categories.elementAt(5);
        break;
        case "Liquide":
        _value = LoginTools.vege ? _categories.elementAt(3) : _categories.elementAt(6);
        break;
      case "Autre":
        _value = LoginTools.vege ? _categories.elementAt(4) : _categories.elementAt(7);
        break;
    }

    Ingredient.newCat = _value;
  }

  void _onChanged(String value) {
    setState(() {
      _value = value;
      Ingredient.newCat = value;
      this.widget.s.setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new DropdownButton(
      value: _value,
      items: _categories.map((String value) {
        return new DropdownMenuItem(
            value: value, child: new Row(children: <Widget>[Text('$value')]));
      }).toList(),
      onChanged: (String value) {
        _onChanged(value);
      },
    );
  }
}
