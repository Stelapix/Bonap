import 'package:flutter/material.dart';
import 'dart:math';

class Loader extends StatefulWidget {
  Loader({Key key, this.isLoading}) : super(key: key);

  final isLoading;

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animationRotation;
  Animation<double> animationRadiusIn;
  Animation<double> animationRadiusOut;

  final double initialRadius = 80.0;
  double radius = 0.0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if(controller != null) controller.dispose();
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    animationRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 1.0, curve: Curves.linear)));

    animationRadiusIn = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn)));

    animationRadiusOut = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.25, curve: Curves.elasticOut)));

    controller.addListener(() {
      setState(() {
        if (controller.value >= 0.75 && controller.value <= 1.0) {
          radius = animationRadiusIn.value * initialRadius;
        } else if (controller.value >= 0.0 && controller.value <= 0.25) {
          radius = animationRadiusOut.value * initialRadius;
        }
      });
    });

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading == true
        ? Container(
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.height / 8,
            child: Center(
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    'assets/icon/icon5.png',
                  ),
                  Center(
                    child: RotationTransition(
                      turns: animationRotation,
                      child: Stack(
                        children: <Widget>[
                          Transform.translate(
                            offset: Offset(radius * cos(2 * pi / 3),
                                radius * sin(2 * pi / 3)),
                            child: Image.asset(
                              'assets/loader/banane.png',
                              width: MediaQuery.of(context).size.width / 8,
                              height: MediaQuery.of(context).size.height / 8,
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(radius * cos(pi), radius * sin(pi)),
                            child: Image.asset(
                              'assets/loader/pomme.png',
                              width: MediaQuery.of(context).size.width / 10,
                              height: MediaQuery.of(context).size.height / 10,
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(radius * cos(4 * pi / 3),
                                radius * sin(4 * pi / 3)),
                            child: Image.asset(
                              'assets/loader/glace.png',
                              width: MediaQuery.of(context).size.width / 10,
                              height: MediaQuery.of(context).size.height / 10,
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(radius * cos(5 * pi / 3),
                                radius * sin(5 * pi / 3)),
                            child: Image.asset(
                              'assets/loader/carotte.png',
                              width: MediaQuery.of(context).size.width / 8,
                              height: MediaQuery.of(context).size.height / 8,
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(radius * cos(6 * pi / 3),
                                radius * sin(6 * pi / 3)),
                            child: Image.asset(
                              'assets/loader/cookie.png',
                              width: MediaQuery.of(context).size.width / 8,
                              height: MediaQuery.of(context).size.height / 8,
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(radius * cos(7 * pi / 3),
                                radius * sin(7 * pi / 3)),
                            child: Image.asset(
                              'assets/loader/salade.png',
                              width: MediaQuery.of(context).size.width / 8,
                              height: MediaQuery.of(context).size.height / 8,
                            ),
                          ),
                          // Transform.translate(
                          //   offset: Offset(radius * cos(7 * pi / 4),
                          //       radius * sin(7 * pi / 4)),
                          //   child: Dot(
                          //     radius: 5.0,
                          //     color: Colors.cyanAccent,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}

// class Dot extends StatelessWidget {
//   final double radius;
//   final Color color;

//   Dot({this.radius, this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         width: this.radius,
//         height: this.radius,
//         decoration: BoxDecoration(color: this.color, shape: BoxShape.circle),
//       ),
//     );
//   }
// }
