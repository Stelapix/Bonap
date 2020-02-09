import 'package:bonap/files/login/forms.dart';
import 'package:bonap/files/widgets/dayMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDownButtonMenu extends StatefulWidget {
  const DropDownButtonMenu({Key key, this.contextMenu}) : super(key: key);
  final contextMenu;

  @override
  _DropDownButtonMenuState createState() => _DropDownButtonMenuState();
}

class _DropDownButtonMenuState extends State<DropDownButtonMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        result == "lost"
            ? FormsState().alertDialog(
                "Pour organiser tes petits plats il faut ...",
                "Ajouter tes ingrédients\n\nFabriquer d'incroyables repas\n\nPlannifier tes menus\n\nSavourer comme il se doit\n\nEt Bonap hein !",
                FlatButton(
                  child: Text("J'ai tout compris !"),
                  onPressed: () {
                    Navigator.of(widget.contextMenu).pop();
                  },
                ),
                widget.contextMenu)
            : FormsState().alertDialog(
                "Tout supprimer ?",
                "",
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('Oulà, non !',
                          style: TextStyle(
                            fontFamily: "Lemonada",
                          )),
                      onPressed: () {
                        Navigator.of(widget.contextMenu).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('Ouaip',
                          style: TextStyle(
                            fontFamily: "Lemonada",
                          )),
                      onPressed: () {
                        setState(() {
                          Day.listDay = List<Day>(14);
                        });
                        Navigator.of(widget.contextMenu).pop();
                      },
                    ),
                  ],
                ),
                widget.contextMenu);
      },
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: "lost",
          child: Text("Besoin d'aide ?",
              style: TextStyle(
                fontFamily: "Lemonada",
              )),
        ),
        const PopupMenuItem<String>(
          value: "deleteAll",
          child: Text('Tout effacer ?',
              style: TextStyle(
                fontFamily: "Lemonada",
              )),
        ),
      ],
    );
  }
}
