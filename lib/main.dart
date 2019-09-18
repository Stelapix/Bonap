import 'package:bonap/presentation/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Bonap\''),
    );
  }


}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[


            const Image(
              alignment: Alignment.topCenter,
              image: AssetImage('assets/logo_bonap.png'),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'CARRY Quentin - LE FEYER Aymeric',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),

                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FloatingActionButton(
                        child: Icon(Custom.github_circled),
                        onPressed: _launchURLGit,
                        tooltip: 'Git',

                      ),

                      FloatingActionButton(
                        child: Icon(Custom.trello),
                        onPressed: _launchURLTrello,
                        tooltip: 'Trello',

                      )
                    ],

                  ),
                ),
                Text(
                  'Bonap est un gestionnaire de menu intelligent \n'
                      'Ajoutez des recettes et commencez votre menu !\n'
                      'La liste de course sera automatiquement générée\n'
                      'Une estimation du prix sera alors générée\n'
                      'Membre d\'une famille ? Ajoutez-la !\n'
                      '\n'
                      'Tout est prêt ? Dans ce cas, Bonap !',
                  style: TextStyle(fontSize: 16.0),
                )


              ],
            )


          ],
        ),

      ),


    );
  }

  void _launchURLGit() async {
    const url = 'https://github.com/AymericLeFeyer/Bonap';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchURLTrello() async {
    const url = 'https://trello.com/b/Vi01l5l7';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
