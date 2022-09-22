import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviewJaundiceResponse extends StatelessWidget {
  late String value ;

   PreviewJaundiceResponse({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (value) {
      case ("Abnormal"):
        {
          return Text.rich(TextSpan(children: [
            TextSpan(
                text: "Abnormal ...", style: TextStyle(color: Colors.red[400])),
            const WidgetSpan(
                child: Icon(Icons.close, color: Color(0XFFFFDD00), size: 20))
          ]));
        }
      case ("Normal"):
        {
          return const Text.rich(TextSpan(children: [
            TextSpan(text: "Normal ... ", style: TextStyle(color: Colors.greenAccent)),
            WidgetSpan(
                child: Icon(
                  Icons.face,
                  color: Colors.white,
                  size: 20,
                ))
          ]));
        }
      default:
        {
            return  Text.rich(
                TextSpan(
                    children: [
                      TextSpan(text: "An Error Occurred ... " , style: TextStyle( color : Colors.red[400])),
                       WidgetSpan(child: Icon(Icons.clear , color : Colors.red[400]))
                    ]
                ),
            );
        }
    }
  }
}