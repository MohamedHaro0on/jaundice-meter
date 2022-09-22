import 'package:jaundice/auth.dart';
import 'package:jaundice/home.dart';
import 'package:jaundice/navigation_drawer.dart';
import 'package:jaundice/shareable/button.dart';
import 'package:jaundice/shareable/text_field.dart';
import 'package:flutter/material.dart';
import 'package:jaundice/shareable/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:string_validator/string_validator.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  late TextEditingController emailController,
      passwordController,
      userNameController,
      newPasswordController,
      confirmPasswordController;
  late final String? email =
      FirebaseAuth.instance.currentUser!.email.toString();
  late final String? username =
      FirebaseAuth.instance.currentUser!.displayName.toString();

  late bool newPasswordTouched = false, userNameTouched = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(
      text: email,
    );
    passwordController = TextEditingController(text: "*******");
    userNameController = TextEditingController(text: username);
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  _onPasswordFocusChange() {
    newPasswordTouched = true;
  }

  _onUserNameFocusChange() {
    userNameTouched = true;
  }

  void _showErrorMessage(String error) {
    final snackBar = SnackBar(
      content: Text(error, style: const TextStyle(color: Colors.redAccent)),
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

  void _navigateToSignIn() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Auth()));
  }

  void _saveNewProfile() async {
    try {
      if (newPasswordTouched == true) {
        if (isLength(newPasswordController.text.toString(), 4, 15) ||
            isLength(confirmPasswordController.text.toString(), 4, 15)) {
          if (equals(newPasswordController.text.toString(),
                  confirmPasswordController.text.toString()) &&
              isLength(newPasswordController.text.toString(), 4, 15)) {
            FirebaseAuth.instance.currentUser!
                .updatePassword(confirmPasswordController.text.trim())
                .then((value) async => {
                      await FirebaseAuth.instance.signOut(),
                      _navigateToSignIn()
                    });
          } else {
            _showErrorMessage(
                "confirm Password and new password are not matching");
          }
        } else {
          _showErrorMessage(
              "the minimum length for the password is 3 and the maximum is 15 character ");
        }
      }

      if (userNameTouched == true) {
        if (isLength(userNameController.text.toString(), 4, 15)) {
          if (userNameController.text !=
              FirebaseAuth.instance.currentUser!.displayName) {
            FirebaseAuth.instance.currentUser!
                .updateDisplayName(userNameController.text.toString())
                .then((value) => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Home()))
                    })
                // ignore: invalid_return_type_for_catch_error
                .catchError((error, stackTrace) => _showErrorMessage(error));
          }
        } else {
          _showErrorMessage(
              "the minimum length for the user name is 3 and the maximum is 15 character");
        }
      }
      if (newPasswordTouched == false && userNameTouched == false) {
        _showErrorMessage("Nothing Changed ...!!");
      }
    } catch (e) {
      _showErrorMessage(e.toString());
    }
  }

  _buildFormButton() {
    double buttonWidth = 100;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
            height: buttonWidth,
            width: buttonWidth,
            child: FittedBox(
                fit: BoxFit.cover,
                child: Button(
                  key: UniqueKey(),
                  backgroundColor: const Color(0XFFFFDD00),
                  tooltip: "Save Profile",
                  onButtonClick: () => _saveNewProfile(),
                  size: 100,
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Color(0XFF000000),
                  ),
                ),
            ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      key: UniqueKey(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            "Profile",
            style: TextStyle(color: Color(0XFF232323)),
          ),
          backgroundColor: const Color(0XFFFFDD00),
          iconTheme: const IconThemeData(color: Color(0XFF232323)),
        ),
        body: SingleChildScrollView(
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    AppTextField(
                      key: UniqueKey(),
                      labelText: 'User name',
                      onTap: () => _onUserNameFocusChange(),
                      controller: userNameController,
                      suffixIcon: const Icon(Icons.person, color: Colors.white),
                    ),
                    AppTextField(
                        key: UniqueKey(),
                        labelText: 'Email',
                        enabled: false,
                        controller: emailController,
                        suffixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.white,
                          size: 20,
                        )),
                    AppTextField(
                        key: UniqueKey(),
                        onTap: () => _onPasswordFocusChange(),
                        labelText: 'New Password',
                        controller: newPasswordController,
                        obscureText: true,
                        suffixIcon: const Icon(
                          Icons.password_outlined,
                          color: Colors.white,
                          size: 20,
                        )),
                    AppTextField(
                        key: UniqueKey(),
                        labelText: 'Confirm Password',
                        controller: confirmPasswordController,
                        obscureText: true,
                        suffixIcon: const Icon(
                          Icons.password_outlined,
                          color: Colors.white,
                          size: 20,
                        )),
                    const SizedBox(height: 40),
                    _buildFormButton(),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
