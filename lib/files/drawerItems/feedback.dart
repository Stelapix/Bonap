import 'dart:async';
import 'dart:io';

import 'package:bonap/files/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';

class FeedbackReport extends StatefulWidget {
  @override
  _FeedbackReportState createState() => new _FeedbackReportState();
}

class _FeedbackReportState extends State<FeedbackReport> {
  List<String> attachments = [];

  final _subjectController = TextEditingController();

  final _bodyController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var image;

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: "BONAP_APP" + _subjectController.text,
      recipients: ["stelapix.bonap@gmail.com"],
      attachmentPaths: attachments,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Feedback",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[OwnColor.yellowLogo, OwnColor.blueLogo])),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: send,
            icon: Icon(Icons.send),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _subjectController,
                  enableInteractiveSelection: false,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: OwnColor.blueLogo, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: OwnColor.blueLogo, width: 0.5),
                      ),
                      hintText: "[BUG] Affichage ...",
                      border: OutlineInputBorder(),
                      labelText: 'Sujet',
                      labelStyle: TextStyle(color: OwnColor.yellowLogo)),
                  cursorColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _bodyController,
                  maxLines: 10,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: OwnColor.blueLogo, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: OwnColor.blueLogo, width: 0.5),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Message',
                      hintText: "Corps du message ...",
                      labelStyle: TextStyle(color: OwnColor.yellowLogo)),
                  cursorColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  width: Constant.width,
                  height: Constant.height / 2,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                        Color.fromRGBO(96, 96, 96, 1),
                        Color.fromRGBO(68, 68, 68, 1)
                      ])),
                  child: image == null
                      ? Text('No image selected.')
                      : Image.file(image),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openImagePicker,
        foregroundColor: Colors.black,
        backgroundColor: OwnColor.blueLogo,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[Icon(Icons.image), Text('Importer une photo')],
        ),
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(20),
      //   child: Text(
      //       "Cette application est une beta, pourriez vous s'il vous plait envoyez vos suggestions ou des bugs que vous auriez trouvé à l'adresse : Stelapix.bonap@gmail.com"),
      // ),
    );
  }

  void _openImagePicker() async {
    if (attachments.length < 1) {
      File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
      image = pick;
      setState(() {
        attachments.add(pick.path);
      });
    } else {
      File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
      image = pick;
      setState(() {
        attachments.removeAt(0);
        attachments.add(pick.path);
      });
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text(
            "Oups",
            style: TextStyle(color: OwnColor.blueLogo),
          ),
          content: Text(
              "Vous ne pouvez envoyer qu'une seule capture d'écran. \nLa précédente a été remplacé."),
        ),
      );
    }
  }
}
