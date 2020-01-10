import 'package:bonap/homePage.dart';
import 'package:flutter/material.dart';
import '../repas.dart';

class DayDisplayMenu extends StatefulWidget{
  final String jour;
  final int midi;
  final int soir;
  final MenuSemaine m;

  DayDisplayMenu(this.jour, this.midi, this.soir, this.m);

  @override
  DayDisplayMenuState createState() => new DayDisplayMenuState();

}

class DayDisplayMenuState extends State<DayDisplayMenu> {
  bool checkboxValueIngr = false;
  List<Meal> allRepas = Meal.listMeal;
  List<Meal> selectedRepas = [];



  @override
  Widget build(BuildContext context) {
    //print(selectedRepas);
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Text(
            widget.jour,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          width: (MediaQuery.of(context).size.width) / 4,
        ),
        ButtonTheme(
          minWidth: (MediaQuery.of(context).size.width) / 3,
          height: 50,
          child: RaisedButton(
            child: (widget.m.repasSemaine[widget.midi].length > 0) ? new Text(
              widget.m.repasSemaine[widget.midi][0].name,
            ) : null,
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(12.0),
              side: BorderSide(color: Color.fromRGBO(0, 191, 255, 1)),
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return _MyDialog(
                        whichOne: widget.midi,
                        ddms: this,
                        repas: Meal.listMeal,
                        selectedRepas: selectedRepas,
                        onSelectedRepasChanged: (repas) {
                          selectedRepas = repas;
                        });
                  });
            },
          ),
        ),
        ButtonTheme(
          minWidth: (MediaQuery.of(context).size.width) / 3,
          height: 50,
          child: RaisedButton(

            child: (widget.m.repasSemaine[widget.soir].length > 0) ? new Text(
              widget.m.repasSemaine[widget.soir][0].name,
            ) : null,
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(12.0),
              side: BorderSide(color: Color.fromRGBO(0, 191, 255, 1)),
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return _MyDialog(
                        whichOne: widget.soir,
                        ddms: this,
                        repas: allRepas,
                        selectedRepas: selectedRepas,
                        onSelectedRepasChanged: (repas) {
                          selectedRepas = repas;
                        }

                        );
                  });
            },
          ),
        ),
      ],
    );
  }

}

class _MyDialog extends StatefulWidget {
  _MyDialog({
    this.whichOne,
    this.repas,
    this.selectedRepas,
    this.onSelectedRepasChanged,
    this.ddms,
  });

  final int whichOne;
  final List<Meal> repas;
  final List<Meal> selectedRepas;
  final ValueChanged<List<Meal>> onSelectedRepasChanged;
  final DayDisplayMenuState ddms;

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<_MyDialog> {
  List<Meal> _tempSelectedRepas = [];


  @override
  void initState() {
    _tempSelectedRepas = widget.selectedRepas;
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
                '   Choix du repas',
                style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              RaisedButton(
                child: Text('OK'),
                onPressed: () {
                  widget.ddms.setState(() {
                    widget.ddms.widget.m.repasSemaine[widget.whichOne] = _tempSelectedRepas;
                    FunctionUpdate.updateListeCourse(widget.ddms.widget.m.repasSemaine);
                    Navigator.pop(context);
                  });

                },
              )

            ],
          ),

          Expanded(
            child: ListView.builder(
                itemCount: widget.repas.length,
                itemBuilder: (BuildContext context, int index) {
                  final repasName = widget.repas[index];
                  return Container(
                    child: CheckboxListTile(
                        title: Row(
                          children: <Widget>[

                            Text('    '),
                            Text(repasName.name),
                          ],
                        ),
                        value: isIn(_tempSelectedRepas, repasName),
                        onChanged: (bool value) {
                          if (value) {
                            if (!isIn(_tempSelectedRepas, repasName)) {
                              setState(() {
                                _tempSelectedRepas.add(repasName);
                              });
                            }
                          } else {
                            if (isIn(_tempSelectedRepas, repasName)) {
                              setState(() {
                                _tempSelectedRepas.removeWhere(
                                        (Meal rep) => rep.name == repasName.name);
                              });
                            }
                          }

                          widget.onSelectedRepasChanged(_tempSelectedRepas);

                        }),
                  );
                }),
          ),
        ],
      ),
    );
  }

  bool isIn(List<Meal> L, Meal R) {
    var b = false;
    for (Meal A in L) {
      b = (A.name == R.name);
      if (b) return true;
    }
    return false;
  }
}