import 'package:jaundice/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jaundice/shareable/button.dart';
import 'package:jaundice/home.dart';
import 'package:get/get.dart';
import 'package:string_validator/string_validator.dart';

import './text_field.dart';

class AppForm extends StatefulWidget {
  final AnimationController? formController, formButtonController;

  final Animation<double>? formOpacityAnimation, buttonSlideAnimation;

  const AppForm(
      {Key? key,
      required this.formOpacityAnimation,
      required this.buttonSlideAnimation,
      required this.formButtonController,
      required this.formController})
      : super(key: key);
  @override
  AppFormState createState() => AppFormState();
}

class AppFormState extends State<AppForm> with TickerProviderStateMixin {
  bool isLogin = true;
  late TextEditingController emailController,
      passwordController,
      userNameController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    userNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Builds the Form Fields : UserName , Email , Password
  _buildFormFields() {
    return FadeTransition(
      opacity: widget.formOpacityAnimation!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          if (!isLogin)
            Column(
              children: <Widget>[
                AppTextField(
                  key: UniqueKey(),
                  labelText: 'User name',
                  controller: userNameController,
                  suffixIcon: const Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
          AppTextField(
              key: UniqueKey(),
              labelText: 'Email',
              controller: emailController,
              suffixIcon: const Icon(
                Icons.email_outlined,
                color: Colors.white,
                size: 20,
              )),
          AppTextField(
              key: UniqueKey(),
              labelText: 'Password',
              controller: passwordController,
              obscureText: true,
              suffixIcon: const Icon(
                Icons.password_outlined,
                color: Colors.white,
                size: 20,
              )),
          const SizedBox(
            height: 30,
          ),
          if (isLogin)
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassword()));
                },
                child: const Text(
                  'Forgot Password ',
                  style: TextStyle(color: Color(0XFFFFDD00)),
                )),
        ],
      ),
    );
  }

  // Shows Error Messages from FireBase
  void _showErrorMessage(String error) {
    //error.split("]")[1].toString()
    final snackBar = SnackBar(
      content: Text(error.toString(),
          style: const TextStyle(color: Colors.redAccent)),
      action: SnackBarAction(
        label: " ",
        textColor: Colors.red,
        onPressed: () {
          SnackbarController.closeCurrentSnackbar();
        },
      ),
    );
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _navigateToHomePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Home()));
  }

  _buildFormButton() {
    double buttonWidth = 100;
    return AnimatedBuilder(
        animation: widget.buttonSlideAnimation!,
        builder: (context, child) {
          return Transform(
              transform: Matrix4.translationValues(
                  widget.buttonSlideAnimation!.value * 100.0, 0, 0),
              child: SizedBox(
                  height: buttonWidth,
                  width: buttonWidth,
                  child: FittedBox(
                      fit: BoxFit.cover,
                      child: Button(
                        key: UniqueKey(),
                        backgroundColor: const Color(0XFFFFDD00),
                        tooltip: "Proceed to the next page",
                        onButtonClick: () async {
                          if (!isLogin) {
                            if (isLength(userNameController.text.toString(), 4))
                              {
                                FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                )
                                    .then((value) {
                                  FirebaseAuth.instance.currentUser
                                      ?.updateDisplayName(
                                      userNameController.text.trim());
                                  _navigateToHomePage();
                                })
                                    .catchError((error, stackTrace) =>
                                // ignore: invalid_return_type_for_catch_error
                                _showErrorMessage(error.toString()))
                                    .timeout((const Duration(seconds: 10)));
                              }
                            else {
                              _showErrorMessage("user name can't be less than 4 character");
                            }

                          } else {
                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim())
                                .then((value) => _navigateToHomePage())
                                .onError((error, stackTrace) =>
                                    _showErrorMessage(error.toString()));
                          }
                        },
                        size: 100,
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Color(0XFF000000),
                        ),
                      ))));
        });
  }

  _buildAuthNavigation() {
    return Row(
      children: <Widget>[
        Text(
          (isLogin) ? 'LOGIN' : 'Sign up',
          style: const TextStyle(color: Colors.white, fontSize: 30),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0, right: 4.0),
          child: Text(
            '/',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        GestureDetector(
          child: Text(
            (isLogin) ? 'Sign up' : 'LOGIN',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          onTap: () {
            // widget.formController!.reset();
            widget.formButtonController!.reset();
            widget.formButtonController!.forward();
            setState(() {
              isLogin = !isLogin;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 200, left: 40, right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          _buildAuthNavigation(),
          _buildFormFields(),
          const SizedBox(height: 15),
          _buildFormButton(),
        ],
      ),
    );
  }
}
