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

  static TextEditingController subjectController;

  static TextEditingController bodyController;

  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var image;

  Future<void> send() async {
    final Email email = Email(
      body: bodyController.text,
      subject: "BONAP_APP_MAIL : " + subjectController.text,
      recipients: ["stelapix.bonap@gmail.com"],
      attachmentPaths: attachments,
    );

    try {
      await FlutterEmailSender.send(email);
      if (attachments.isNotEmpty) {
        attachments.removeAt(0);
        setState(() {
          image = null;
        });
      }
      subjectController.text = "";
      bodyController.text = "";
      scaffoldKey = GlobalKey<ScaffoldState>();
    } catch (error) {
      print(error);
    }
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
          image != null
              ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text(
                          "Voulez-vous retirez la photo ?",
                          style: TextStyle(color: OwnColor.blueLogo),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Non'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Oui'),
                            onPressed: () {
                              attachments.removeAt(0);
                              setState(() {
                                image = null;
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  })
              : Container(),
          IconButton(
              icon: Icon(Icons.info_outline, color: Colors.black),
              onPressed: () {
                showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text(
                      "N'hésitez pas !",
                      style: TextStyle(color: OwnColor.blueLogo),
                    ),
                    content: Text(
                        "Cette application est une bêta,\nsi vous trouvez un bug\nenvoyez nous un mail avec\neventuellement un screenshot.\n\nMerci !"),
                  ),
                );
              }),
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
                  controller: subjectController,
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
                      labelText: 'Objet',
                      labelStyle: TextStyle(color: OwnColor.yellowLogo)),
                  cursorColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  enableInteractiveSelection: false,
                  controller: bodyController,
                  maxLines: 5,
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
                      alignLabelWithHint: true,
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
                  height: Constant.height / 2.5,
                  child: image == null
                      ? Center(
                          child: Text('Vous pouvez sélectionner une image.'))
                      : Image.file(image),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openImagePicker,
        foregroundColor: Colors.black,
        backgroundColor: OwnColor.blueLogo,
        icon: Icon(Icons.image),
        label: Text('Importer une photo'),
      ),
    );
  }

  void _openImagePicker() async {
    if (attachments.isEmpty) {
      File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (pick != null) {
        image = pick;
        setState(() {
          attachments.add(pick.path);
        });
      }
    } else {
      File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (pick != null) {
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
}
