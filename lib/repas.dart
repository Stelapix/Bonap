import 'package:flutter/material.dart';

class RepasPage extends StatefulWidget {
  @override
  _RepasPageState createState() => new _RepasPageState();
}

class _RepasPageState extends State<RepasPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Repas'),
      ),
    );
  }
}