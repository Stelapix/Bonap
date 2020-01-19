import 'package:bonap/repas.dart';
import 'package:bonap/homePage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DayMenu extends StatefulWidget{
  final String dayName;
  final int weekday;
  

  DayMenu(this.dayName, this.weekday);

  @override
  DayMenuState createState() => DayMenuState();
}


class DayMenuState extends State<DayMenu> {
  bool currentDay = false;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    

    final bleu = Color.fromRGBO(0, 191, 255, 1);
    // Bold the current day
    var now = DateTime.now();
    switch (now.weekday) {
      case DateTime.monday:
        if (widget.dayName == "Lundi") currentDay = true;
        break;
      case DateTime.tuesday:
        if (widget.dayName == "Mardi") currentDay = true;
        break;
      case DateTime.wednesday:
        if (widget.dayName == "Mercredi") currentDay = true;
        break;
      case DateTime.thursday:
        if (widget.dayName == "Jeudi") currentDay = true;
        break;
      case DateTime.friday:
        if (widget.dayName == "Vendredi") currentDay = true;
        break;
      case DateTime.saturday:
        if (widget.dayName == "Samedi") currentDay = true;
        break;
      case DateTime.sunday:
        if (widget.dayName == "Dimanche") currentDay = true;
        break;
      default:
        break;
    }
    // Column
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.dayName +' '+ MenuSemaine.getTheNDayOfTheWeek(widget.weekday).toString().split('/')[0],
              style: currentDay ? 
              TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: bleu,
              ) :
              TextStyle(
                fontSize: 20,
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
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 5),
      child: Container(
        
        width: MediaQuery.of(context).size.width / 3,
        
        child: OutlineButton(
          
          padding: EdgeInsets.all(8.0),
          onPressed: () {
            setState(() {
              showDialog(
                context: context,
                      builder: (context) {
                        return AddMealDialog(this);
                      });
             
            });

          },
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    
                    widget.listMeal.length > 0 ? 
                    Text(
                      nameWithoutTheEnd(widget.listMeal[0].name),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: widget.listMeal[0].fav ? FontWeight.bold : FontWeight.normal),

                    ) : 
                    Icon(Icons.add),
                  ],
                ),

                widget.listMeal.length > 0 ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
        ),
      ),
    );
  }

  String nameWithoutTheEnd(String s) {
    if (getLenghtOfText(s) < 100) return s;
    else {
      String s2 = "";
      int i = 0;
      while (getLenghtOfText(s2) < 90) {
        s2 += s[i];
        i++;
      }
      return s2 + '...';
    }
  
  }

  double getLenghtOfText(String s) {
    final constraints = BoxConstraints(
      maxWidth: 200.0,
      minHeight: 0.0,
      minWidth: 0.0,
    );

    RenderParagraph renderParagraph = RenderParagraph(
      TextSpan(
        text: s,
        style: TextStyle(fontSize: 15),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    renderParagraph.layout(constraints);
    return renderParagraph.getMinIntrinsicWidth(15).ceilToDouble();

  }


}

class AddMealDialog extends StatefulWidget {
  final DayButtonState dbs;

  AddMealDialog(this.dbs);

  @override
  AddMealDialogState createState() => AddMealDialogState();
}

class AddMealDialogState extends State<AddMealDialog> {

  
  @override
  void initState() {  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Ajouter des repas"),
      actions: <Widget>[
        FlatButton(
          child: Text("Ok"),
          onPressed: () {
            widget.dbs.setState(() => true);
            Navigator.of(context).pop();
          },
        )

      ],
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.4,
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: displayMeal(),
            )
          ],
        ),

      )

    );
  }

  ListView displayMeal() {
    List<Meal> newList = new List();
    var listMeal = Meal.listMeal;
    if (Meal.filter != "") {
      for (Meal m in Meal.listMeal) {
        if (m.name.contains(Meal.filter)) {
          newList.add(m);
        }
      }
    } else
      newList = listMeal;

    return ListView(
      shrinkWrap: true,
      children: newList
          .map(
            (data) => new Container(
              child: ListTile(
                title: Text(data.name),
                subtitle: Text(data.listIngredientToString()),
                trailing: widget.dbs.widget.listMeal.contains(data) ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
                onTap: () {
                  setState(() {
                    
                  });
                  if (widget.dbs.widget.listMeal.contains(data)) {
                    widget.dbs.widget.listMeal.remove(data);
                  }
                  else
                  widget.dbs.widget.listMeal.add(data);

                },
              ),
            ),
          )
          .toList(),
    );
  }

  
  
}

class WeekMenu extends StatefulWidget{
  @override
  WeekMenuState createState() => WeekMenuState();
}

class WeekMenuState extends State<WeekMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DayMenu("Lundi", 1),
        DayMenu("Mardi", 2),
        DayMenu("Mercredi", 3),
        DayMenu("Jeudi", 4),
        DayMenu("Vendredi", 5),
        DayMenu("Samedi", 6),
        DayMenu("Dimanche", 7),
        
      ],
    );
  }
  
}