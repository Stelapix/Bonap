import 'package:bonap/files/data/dataStorage.dart';
import 'package:bonap/files/drawerItems/ingredients.dart';
import 'package:bonap/files/drawerItems/meal.dart';
import 'package:bonap/files/drawerItems/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bonap/files/tools.dart';
import 'package:intl/intl.dart';

import '../data/dataStorage.dart';

class Weeks {
  static List<Day> week_1 = new List<Day>(14); // Last Week (weekID = -1)
  static List<Day> week0 = new List<Day>(14); // Current Week (weekID = 0)
  static List<Day> week1 = new List<Day>(14); // Next Week (weekID = 1)
  static List<Day> week2 = new List<Day>(14); // Week + 2 (weekID = 2)
  static int weekID = 0;
  static int weekNumber;

  static void changeWeek(String p) {
    // Save listDay at the right place
    if (weekID == -1) week_1 = Day.listDay;
    if (weekID == 0) week0 = Day.listDay;
    if (weekID == 1) week1 = Day.listDay;
    if (weekID == 2) week2 = Day.listDay;

    // Load the week and save it in listDay
    if (p == '+') {
      if (weekID == -1) Day.listDay = week0;
      if (weekID == 0) Day.listDay = week1;
      if (weekID == 1) Day.listDay = week2;
    } else if (p == '-') {
      if (weekID == 0) Day.listDay = week_1;
      if (weekID == 1) Day.listDay = week0;
      if (weekID == 2) Day.listDay = week1;
    }

    // Update weekID
    if (p == '+') weekID++;
    if (p == '-') weekID--;
  }

  static void newWeek() {
    week_1 = week0;
    week0 = week1;
    week1 = week2;
    week2 = new List<Day>(14);
    DataStorage.saveWeek();
  }

  static void updateWeekNumber() {
    DateTime now = DateTime.now();
    int dayOfYear = int.parse(DateFormat("D").format(now));
    int n = ((dayOfYear - now.weekday + 10) ~/ 7);
    
    if (Weeks.weekNumber != n) {
      print("NEW WEEK OMG");
      Weeks.newWeek();
      Weeks.weekNumber = n;
      Day.listDay = week0;
    }
  }
}

class Day {
  static List<Day> listDay = new List<Day>(14);

  List<Meal> listMeal;
  Ingredient ing1;
  Ingredient ing2;
  Ingredient ing3;
  int index;

  Day() {
    this.listMeal = new List<Meal>();
    this.ing1 = null;
    this.ing2 = null;
    this.ing3 = null;
    this.index = -1;
  }

  // Sauvegarde et chargement
  Day.fromJson(Map<String, dynamic> json)
      : listMeal = createList(json['listMeal']),
        ing1 = createIng(json['ing1']),
        ing2 = createIng(json['ing1']),
        ing3 = createIng(json['ing1']),
        index = json['index'];

  Map<String, dynamic> toJson() => {
        'listMeal': listMeal,
        'ing1': ing1,
        'ing2': ing2,
        'ing3': ing3,
        'index': index,
      };

  static List<Meal> createList(List<dynamic> s) {
    List<Meal> L = new List<Meal>();
    for (int i = 0; i < s.length; i++) {
      Meal m = new Meal(s[i]['name'], Meal.createList(s[i]['ingredients']));
      m.fav = s[i]['fav'];

      L.add(m);
    }
    return L;
  }

  static Ingredient createIng(dynamic s) {
    Ingredient i = new Ingredient(s['name'], s['cat']);
    return i;
  }
}

class DayMenu extends StatefulWidget {
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
    if (Weeks.weekNumber == MenuSemaine.getTheNumberOfWeek()) {
      
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
    } else currentDay = false;

    // Column
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.dayName +
                  ' ' +
                  MenuSemaine.getTheNDayOfTheWeek(widget.weekday)
                      .toString()
                      .split('/')[0],
              style: currentDay
                  ? TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: bleu,
                    )
                  : TextStyle(
                      fontSize: 20,
                    ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DayButton((widget.weekday - 1) * 2),
            DayButton((widget.weekday - 1) * 2 + 1),
          ],
        )
      ],
    );
  }
}

class DayButton extends StatefulWidget {
  final int index;

  DayButton(this.index);

  @override
  DayButtonState createState() => DayButtonState();
}

class DayButtonState extends State<DayButton> {
  bool settingsMode = false;
  bool loaded = false;

  Ingredient ing1;
  Ingredient ing2;
  Ingredient ing3;

  @override
  void initState() {
    loaded = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Update the ingrdients icons
    if (Day.listDay[widget.index] != null) {
      if (Day.listDay[widget.index].listMeal[0].listIngredient.length > 0)
        Day.listDay[widget.index].ing1 =
            Day.listDay[widget.index].listMeal[0].listIngredient[0];
      if (Day.listDay[widget.index].listMeal[0].listIngredient.length > 1)
        Day.listDay[widget.index].ing2 =
            Day.listDay[widget.index].listMeal[0].listIngredient[1];
      if (Day.listDay[widget.index].listMeal[0].listIngredient.length > 2)
        Day.listDay[widget.index].ing3 =
            Day.listDay[widget.index].listMeal[0].listIngredient[2];
    }
    // Size padding
    var size = 9;

    // Settings mode
    if (settingsMode == null) settingsMode = false;
    if (Day.listDay[widget.index] == null) settingsMode = false;
    if (Day.listDay[widget.index] != null) {
      if (!(Day.listDay[widget.index].listMeal.length > 0))
        settingsMode = false;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 5),
      child: Container(
        width: Constant.width / 2.5,
        child: OutlineButton(
          padding: EdgeInsets.all(8.0),
          onPressed: () {
            setState(() {
              Day.listDay[widget.index] != null &&
                      Day.listDay[widget.index].listMeal.length > 0
                  ? showDialog(
                      context: context,
                      builder: (context) {
                        return DisplayInfosDialog(
                            this, Day.listDay[widget.index].listMeal);
                      })
                  : showDialog(
                      context: context,
                      builder: (context) {
                        return AddMealDialog(this, widget.index);
                      });
            });
          },
          onLongPress: () {
            setState(() {
              Day.listDay[widget.index] != null &&
                      Day.listDay[widget.index].listMeal.length > 0
                  ? settingsMode = !settingsMode
                  : showDialog(
                      context: context,
                      builder: (context) {
                        return AddMealDialog(this, widget.index);
                      });
            });
          },
          child: Container(
            width: Constant.width / 2.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    (Day.listDay[widget.index] == null || Day.listDay[widget.index].listMeal.length == 0)
                        ? (Weeks.weekID == -1
                            ? Icon(Icons.do_not_disturb)
                            : Icon(Icons.add))
                        : (RenderingText.getLenghtOfText(Day
                                    .listDay[widget.index].listMeal[0].name) >
                                115)
                            ? Container(
                                width: Constant.width / 3.5,
                                height: Constant.height / 50,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                    Text(
                                      Day.listDay[widget.index].listMeal[0]
                                          .name,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: Day.listDay[widget.index]
                                                  .listMeal[0].fav
                                              ? FontWeight.bold
                                              : FontWeight.normal),
                                    ),
                                  ],
                                ),
                              )
                            : Text(
                                RenderingText.nameWithoutTheEnd(
                                    Day.listDay[widget.index].listMeal[0].name,
                                    1),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: Day.listDay[widget.index]
                                            .listMeal[0].fav
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                          ),
                  ],
                ),
                settingsMode
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            tooltip: "Changer les repas",
                            icon: Icon(Icons.settings),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AddMealDialog(this, widget.index);
                                  });
                              loaded = true;
                            },
                          ),
                          IconButton(
                            tooltip: "Supprimer les repas",
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DelMealDialog(this, widget.index);
                                  });
                              loaded = true;
                            },
                          ),
                        ],
                      )
                    : Day.listDay[widget.index] != null && Day.listDay[widget.index].listMeal.length != 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Day.listDay[widget.index].listMeal[0]
                                          .listIngredient.length >
                                      0
                                  ? Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: SizedBox(
                                        width: Constant.width / size,
                                        child: IconButton(
                                          icon: Day
                                              .listDay[widget.index].ing1.icon,
                                          onPressed: () {
                                            setState(() {
                                              settingsMode = !settingsMode;
                                            });
                                          },
                                          tooltip: Day
                                              .listDay[widget.index].ing1.name,
                                        ),
                                      ),
                                    )
                                  : Text(''),
                              Day.listDay[widget.index].listMeal[0]
                                          .listIngredient.length >
                                      1
                                  ? Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: SizedBox(
                                        width: Constant.width / size,
                                        child: IconButton(
                                          icon: Day
                                              .listDay[widget.index].ing2.icon,
                                          onPressed: () {
                                            setState(() {
                                              settingsMode = !settingsMode;
                                            });
                                          },
                                          tooltip: Day
                                              .listDay[widget.index].ing2.name,
                                        ),
                                      ),
                                    )
                                  : Text(''),
                              Day.listDay[widget.index].listMeal[0]
                                          .listIngredient.length >
                                      2
                                  ? Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: SizedBox(
                                        width: Constant.width / size,
                                        child: IconButton(
                                          icon: Day
                                              .listDay[widget.index].ing3.icon,
                                          onPressed: () {
                                            setState(() {
                                              settingsMode = !settingsMode;
                                            });
                                          },
                                          tooltip: Day
                                              .listDay[widget.index].ing3.name,
                                        ),
                                      ),
                                    )
                                  : Text(''),
                            ],
                          )
                        : Row(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}

class ChangeIngredientDialog extends StatefulWidget {
  final DayButtonState dbs;
  final int ing;
  final Meal meal;

  ChangeIngredientDialog(this.dbs, this.ing, this.meal);

  @override
  ChangeIngredientDialogState createState() => ChangeIngredientDialogState();
}

class ChangeIngredientDialogState extends State<ChangeIngredientDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Changer l'ingrédient principal"),
      actions: <Widget>[
        FlatButton(
          child: Text("Retour"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
      content: Container(
        width: Constant.width * 0.8,
        height: Constant.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: widget.meal.listIngredient
                    .map((data) => new ListTile(
                          title: Text(
                            data.name,
                            style:
                                ((data == widget.dbs.ing1 && widget.ing == 1) ||
                                        (data == widget.dbs.ing2 &&
                                            widget.ing == 2) ||
                                        (data == widget.dbs.ing3 &&
                                            widget.ing == 3))
                                    ? TextStyle(fontWeight: FontWeight.bold)
                                    : TextStyle(fontWeight: FontWeight.normal),
                          ),
                          leading: data.icon,
                          onTap: () {
                            if (widget.ing == 1) widget.dbs.ing1 = data;
                            if (widget.ing == 2) widget.dbs.ing2 = data;
                            if (widget.ing == 3) widget.dbs.ing3 = data;

                            widget.dbs.setState(() => true);
                            DataStorage.saveWeek();

                            Navigator.of(context).pop();
                          },
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DelMealDialog extends StatefulWidget {
  final DayButtonState dbs;
  final int index;

  DelMealDialog(this.dbs, this.index);

  @override
  DelMealDialogState createState() => DelMealDialogState();
}

class DelMealDialogState extends State<DelMealDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Supprimer ce repas ?"),
      actions: <Widget>[
        FlatButton(
          child: Text("Non"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Oui"),
          onPressed: () {
            Day.listDay[widget.index].listMeal
                .removeRange(0, Day.listDay[widget.index].listMeal.length);
            Day.listDay[widget.index].ing1 = null;
            Day.listDay[widget.index].ing2 = null;
            Day.listDay[widget.index].ing3 = null;
            Day.listDay[widget.index] = null;
            widget.dbs.setState(() => true);
            DataStorage.saveWeek();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

class AddMealDialog extends StatefulWidget {
  final DayButtonState dbs;
  final int index;

  AddMealDialog(this.dbs, this.index);

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
        title: Meal.listMeal.length > 0
            ? Text("Ajouter des repas")
            : Text("Vous allez trop vite !"),
        actions: <Widget>[
          FlatButton(
            child: Text("Ok"),
            onPressed: Meal.listMeal.length > 0
                ? () {
                    if (Day.listDay[widget.index] != null &&
                        Day.listDay[widget.index].listMeal.length != 0) {
                      if (Day.listDay[widget.index].listMeal[0].listIngredient
                              .length >
                          0)
                        widget.dbs.ing1 = Day.listDay[widget.index].listMeal[0]
                            .listIngredient[0];

                      if (Day.listDay[widget.index].listMeal[0].listIngredient
                              .length >
                          1)
                        widget.dbs.ing2 = Day.listDay[widget.index].listMeal[0]
                            .listIngredient[1];

                      if (Day.listDay[widget.index].listMeal[0].listIngredient
                              .length >
                          2)
                        widget.dbs.ing3 = Day.listDay[widget.index].listMeal[0]
                            .listIngredient[2];

                      List<Day> copy = Day.listDay;

                      for (int i = 0; i < copy.length; i++) {
                        if (Day.listDay.contains(copy[i]) && copy[i] != null) {
                          if (copy[i] != null) {
                            if (copy[i].index == widget.index) {
                              copy[i].listMeal =
                                  Day.listDay[widget.index].listMeal;
                            }
                          }
                        } else {
                          Day d = new Day();
                          d.index = widget.index;
                          d.listMeal = Day.listDay[widget.index].listMeal;
                          d.ing1 = d.listMeal[0].listIngredient.length > 0
                              ? d.listMeal[0].listIngredient[0]
                              : null;
                          d.ing2 = d.listMeal[0].listIngredient.length > 1
                              ? d.listMeal[0].listIngredient[1]
                              : null;
                          d.ing3 = d.listMeal[0].listIngredient.length > 2
                              ? d.listMeal[0].listIngredient[2]
                              : null;
                          Day.listDay[widget.index] = d;
                        }
                      }
                    }

                    

                    DataStorage.saveWeek();

                    widget.dbs.setState(() => true);
                    Navigator.of(context).pop();
                  }
                : () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => RepasPage()));
                  },
          )
        ],
        content: Meal.listMeal.length > 0
            ? Container(
                width: Constant.width * 0.8,
                height: Meal.listMeal.length > 5 ? Constant.height * 0.4 : Constant.height * (Meal.listMeal.length / 14),
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
            : Container(
              child: Text('Commencez par ajouter des repas'),
            ));
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
                trailing: Day.listDay[widget.index] != null &&
                        Day.listDay[widget.index].listMeal.contains(data)
                    ? Icon(Icons.check_box)
                    : Icon(Icons.check_box_outline_blank),
                onTap: () {
                  // print(Day.listDay[widget.index].listMeal.toString());
                  
                  setState(() {});
                  if (Day.listDay[widget.index] != null &&
                      Day.listDay[widget.index].listMeal.contains(data)) {
                    Day.listDay[widget.index].listMeal.remove(data);
                  } else if (Day.listDay[widget.index] == null) {
                    Day.listDay[widget.index] = new Day();
                    Day.listDay[widget.index].listMeal.add(data);
                  } else
                    Day.listDay[widget.index].listMeal.add(data);
                },
              ),
            ),
          )
          .toList(),
    );
  }
}

class DisplayInfosDialog extends StatefulWidget {
  final DayButtonState dbs;
  final List<Meal> listMeal;

  DisplayInfosDialog(this.dbs, this.listMeal);

  @override
  DisplayInfosDialogState createState() => DisplayInfosDialogState();
}

class DisplayInfosDialogState extends State<DisplayInfosDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var n = widget.listMeal.length;
    for (Meal m in widget.listMeal) n += m.listIngredient.length;
    return AlertDialog(
      actions: <Widget>[
        FlatButton(
          child: Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
      content: Container(
        width: Constant.width * 0.8,
        height: n > 6 ? Constant.height * 0.4 : Constant.height * (n/15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: displayInfos(),
            )
          ],
        ),
      ),
    );
  }

  ListView displayInfos() {
    return ListView(
        shrinkWrap: true,
        children: widget.listMeal
            .map((data) => new Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          data.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Column(
                        children: data.listIngredient
                            .map((data2) => new Container(
                                    child: ListTile(
                                  title: Text(data2.name),
                                  leading: data2.icon,
                                )))
                            .toList(),
                      )
                    ],
                  ),
                ))
            .toList());
  }
}

class WeekMenu extends StatefulWidget {
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
