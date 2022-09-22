// ignore: file_names
import 'package:jaundice/shareable/button.dart';
import 'package:jaundice/shareable/layout.dart';
import 'package:jaundice/shareable/text_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final auth = FirebaseAuth.instance;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  _showMessage(String error) {
    final snackBar = SnackBar(
      content: Text(error.toString(),
          style: const TextStyle(color: Colors.redAccent)),
      action: SnackBarAction(
        label: " ",
        textColor: Colors.red,
        onPressed: () {},
      ),
    );
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      key: UniqueKey(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Reset Password',
              style: TextStyle(color: Color(0XFF232323))),
          backgroundColor: const Color(0XFFFFDD00),
          iconTheme: const IconThemeData(color: Color(0XFF232323)),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: AppTextField(
                key: UniqueKey(),
                controller: emailController,
                labelText: "Email",
                suffixIcon: const Icon(
                  Icons.email_outlined,
                  color: Color(0XFFFFDD00),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Button(
                    key: UniqueKey(),
                    backgroundColor: const Color(0XFFFFDD00),
                    tooltip: "Send Code",
                    size: 70,
                    onButtonClick: () {
                      auth
                          .sendPasswordResetEmail(
                              email: emailController.text.trim())
                          .then((value) => {
                                _showMessage(
                                    "an Email has been sent Check the spam Folder"),
                                Navigator.of(context).pop()
                              })
                          .onError((error, stackTrace) =>
                              {_showMessage(error.toString())});
                    },
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Color(0XFF000000),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
