import 'package:flutter/material.dart';

class ListeCoursePage extends StatefulWidget {
  @override
  _ListeCoursePageState createState() => new _ListeCoursePageState();
}

class _ListeCoursePageState extends State<ListeCoursePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Liste de Course'),
      ),
    );
  }
}