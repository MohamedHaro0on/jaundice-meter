import 'package:Jaundice/Login_SignUp_Page.dart';
import 'package:Jaundice/shareable/layout.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
            () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const LoginSignUpPage())));
  }


  @override
  Widget build(BuildContext context) {
    return Layout(
        key : UniqueKey(),
        child : Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/2.png' , alignment: Alignment.center),
              ],
            ),
          ),
        )
    );
  }
}