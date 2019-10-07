import 'package:flutter/material.dart';

class IngredientsPage extends StatefulWidget {
  @override
  _IngredientsPageState createState() => new _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  List<String>ingredients = [];
  String newIngr = '';


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
              children: ingredients.map((data) => ListTile(title: Text(data))).toList(),
            ),
          ],
        )
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterIngredient,
        tooltip: 'Ajouter un ingrédient',
        backgroundColor: Color.fromRGBO(0, 191, 255, 1),
        child: Icon(Icons.add),


      ),
    );
  }

  void _ajouterIngredient() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Ajouter un ingrédient'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Nom', hintText: 'Frite, Steak, Salade ...'),
                    onChanged: (value) {
                      newIngr = value;
                    },
                  ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                ingredients.add(newIngr);
                Navigator.of(context).pop();
              },
            ),
          ],

        );
      },
    );
  }

}