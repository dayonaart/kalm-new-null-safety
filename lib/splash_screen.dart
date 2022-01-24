import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? controller;
  @override
  void initState() {
    // TODO: implement initState
    controller =
        AnimationController(duration: const Duration(seconds: 4), vsync: this);
    animation = CurvedAnimation(parent: controller!, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller!.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller!.forward();
        }
      });
    controller!.forward();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/wave/wave5.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          GestureDetector(
            onTap: () {
              // _fecthUser();
            },
            child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [AnimatedLogo(animation: animation!)],
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset('assets/wave/wave.png', fit: BoxFit.fill),
          )
        ],
      ),
    );
  }
}

class AnimatedLogo extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  static final _sizeTween = Tween<double>(begin: 0, end: 200);

  AnimatedLogo({@required Animation<double>? animation})
      : super(listenable: animation!);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Opacity(
        opacity: _opacityTween.evaluate(animation),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: _sizeTween.evaluate(animation),
          width: _sizeTween.evaluate(animation),
          child: Image.asset('assets/icon/kalm.png'),
        ),
      ),
    );
  }
}
