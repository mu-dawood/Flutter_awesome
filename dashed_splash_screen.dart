import 'dart:math';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Random rnd = Random();
  void hideSplash() async {
    // TODO hide splash
  }

  Animation<double> generateAnimation(
    double begin,
    double end,
    double from,
    double to,
  ) {
    return Tween(begin: from, end: to).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(
        begin,
        end,
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);

    controller.forward().then((d) {
      hideSplash(user.authenticated);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          for (var i = 0; i < 10; i++)
            for (var x = 0; x < 10; x++)
              buildLogoPart(i == 0 ? 0 : i / 10, x == 0 ? 0 : x / 10),
        ],
      ),
    );
  }

  Widget buildLogoPart(double top, double left) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var angle = rnd.nextInt(10);
    var _top = rnd.nextInt((h * 2).toInt()) - h;
    var _left = rnd.nextInt((w * 2).toInt()) - w;
    var animation1 = generateAnimation(0.0, 0.25, 0.0, 1.0);
    var animation2 = generateAnimation(0.3, 0.9, 1.0, 0.0);
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Positioned.fill(
          key: Key("item_$top _ $left"),
          child: Transform.scale(
            scale: animation1.value,
            child: Transform.rotate(
              angle: angle * animation2.value,
              child: LogoClipper(top: top, left: left),
            ),
          ),
          top: _top * animation2.value,
          left: _left * animation2.value,
        );
      },
    );
  }
}

class LogoClipper extends StatelessWidget {
  final double top;
  final double left;
  const LogoClipper({Key key, this.top = 0, this.left = 0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRect(
        clipper: MyClipper(top: top, left: left),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: FlutterLogo(),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Rect> {
  final double top;
  final double left;

  MyClipper({this.top = 0, this.left = 0});
  @override
  Rect getClip(Size size) {
    var w = size.width;
    var h = size.height;
    var _top = top * h;
    var _left = left * w;
    return Rect.fromLTWH(_left, _top, w * 0.1, h * 0.1);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
