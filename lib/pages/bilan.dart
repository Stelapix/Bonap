import 'package:flutter/material.dart';

class BilanPage extends StatefulWidget {
  @override
  _BilanPageState createState() => new _BilanPageState();
}

class _BilanPageState extends State<BilanPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Bilan diététique'),
      ),
    );
  }
}