import 'package:flutter/material.dart';

class Checkup extends StatefulWidget {
  @override
  _CheckupState createState() => new _CheckupState();
}

class _CheckupState extends State<Checkup> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Bilan diététique'),
      ),
    );
  }
}