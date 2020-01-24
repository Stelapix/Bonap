import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => new _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
            "Cette application est une beta, pourriez vous s'il vous plait envoyez vos suggestions ou des bugs que vous auriez trouvé à l'adresse : Stelapix.bonap@gmail.com"),
      ),
    );
  }
}
