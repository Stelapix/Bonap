import 'package:bonap/repas.dart';
import 'package:flutter/material.dart';

class DayMenu extends StatefulWidget{
  @override
  DayMenuState createState() => DayMenuState();
}


class DayMenuState extends State<DayMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Lundi",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[            
            DayButton(),
            DayButton(),

          ],
        )
      ],
    );
  }
  
}

class DayButton extends StatefulWidget {
  final List<Meal> listMeal = new List<Meal>();

  @override
  DayButtonState createState() => DayButtonState();

}

class DayButtonState extends State<DayButton>{
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        setState(() {
          widget.listMeal.add(Meal.listMeal[0]);
        });

      },
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                widget.listMeal.length > 0 ? 
                Text(
                  widget.listMeal[0].name
                ) : 
                Icon(Icons.add),
              ],
            ),

            widget.listMeal.length > 0 ? Row(
              children: <Widget>[
                widget.listMeal[0].listIngredient.length > 0 ?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.listMeal[0].listIngredient[0].icon,
                ) : Text(''),

                widget.listMeal[0].listIngredient.length > 1 ?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.listMeal[0].listIngredient[1].icon,
                ) : Text(''),

                widget.listMeal[0].listIngredient.length > 2 ?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.listMeal[0].listIngredient[2].icon,
                ) : Text(''),
                
              ],
            ) : 
            Row(),
          ],
        ),

      ),
    );
  }


}
