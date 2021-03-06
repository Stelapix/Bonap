import 'package:flutter/material.dart';

class DropDownButtonMain extends StatefulWidget {
  @override
  _DropDownButtonMainState createState() => _DropDownButtonMainState();
}

class _DropDownButtonMainState extends State<DropDownButtonMain> {
  String _value;
  List<String> _midiSoir = new List<String>();

  @override
  void initState() {
    super.initState();
    _midiSoir.addAll(["Midi", "Soir"]);
    _value = _midiSoir.elementAt(0);
  }

  void _onChanged(String value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new DropdownButton(
      value: _value,
      items: _midiSoir.map((String value) {
        return new DropdownMenuItem(
            value: value,
            child: new Row(children: <Widget>[
              Text('$value',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            ]));
      }).toList(),
      onChanged: (String value) {
        _onChanged(value);
      },
    );
  }
}
