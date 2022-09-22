import 'package:jaundice/shareable/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'shareable/form.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  AuthState createState() => AuthState();
}

class AuthState extends State<Auth> with TickerProviderStateMixin {
  final double topPolygonSize = 270;
  late AnimationController _logoController,
      _formController,
      _formButtonController;

  late Animation<double> _logoSlideAnimation,
      _formOpacityAnimation,
      _buttonSlideAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    _formController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    _formButtonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    _logoSlideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _logoController,
            curve: const Interval(0, 1.0, curve: Curves.easeIn)));

    _formOpacityAnimation =
        CurvedAnimation(parent: _formController, curve: Curves.easeIn);

    _buttonSlideAnimation = Tween<double>(begin: 1.5, end: 0.0).animate(
        CurvedAnimation(
            parent: _formButtonController,
            curve: const Interval(0, 1.0, curve: Curves.easeIn)));

    _logoController
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _formController.forward();
        }
      })
      ..forward();

    _formController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _formButtonController.forward();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _logoController.dispose();
    _formController.dispose();
    _formButtonController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      key: UniqueKey(),
      child: Form(
          child: Stack(children: <Widget>[
        _buildTopPolygon(),
        _buildLogoText(),
        AppForm(
          buttonSlideAnimation: _buttonSlideAnimation,
          formButtonController: _formButtonController,
          formController: _formController,
          formOpacityAnimation: _formOpacityAnimation,
        ),
      ])),
    );
  }

  _buildTopPolygon() {
    // The Yellow Polygon
    return Positioned(
      top: -1 * (25 / 100 * topPolygonSize),
      right: -1 * (23 / 100 * topPolygonSize),
      child: SizedBox(
        height: topPolygonSize,
        width: topPolygonSize,
        child: ClipPolygon(
          sides: 6,
          borderRadius: 10,
          child: Container(
            color: const Color(0XFFFFDD00),
          ),
        ),
      ),
    );
  }

  _buildLogoText() {
    return Positioned(
      top: 15 / 100 * topPolygonSize, // Top Polygon Size
      right: 0 / 100 * topPolygonSize, // Top Polygon Size
      child: AnimatedBuilder(
        animation: _logoSlideAnimation,
        builder: (context, child) {
          return Transform(
              transform: Matrix4.translationValues(
                  0, _logoSlideAnimation.value * 100, 0),
              child: Image.asset(
                'assets/images/Logo_Logo_Logo.png',
                height: 130,
                alignment: Alignment.center,
                fit: BoxFit.cover,
              ));
        },
      ),
    );
  }
}
