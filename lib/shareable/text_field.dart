
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String labelText ;
  final Icon? suffixIcon;
  final TextEditingController controller ;
  final bool? obscureText ;

  AppTextField (
      {
        required Key key ,
        this.obscureText = false,
        this.suffixIcon ,
        required this.controller,
        required this.labelText
      }
  ): super(key: key);


  @override
  TextFieldState createState() => TextFieldState();
}


class TextFieldState extends State<AppTextField> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: TextFormField(
          controller: widget.controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFFFFDD00))
              ),
              labelText: widget.labelText,
              labelStyle: const TextStyle(color: Color(0XFF9a9a9a)),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              suffixIcon: widget.suffixIcon!
          ),
          obscureText: widget.obscureText!,
        )
    );
  }
}