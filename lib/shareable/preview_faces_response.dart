import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviewFacesResponse extends StatelessWidget {
  late int value ;

  PreviewFacesResponse({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build (BuildContext context) {
    switch (value) {
      case (0) : {
        return Text.rich(TextSpan(
          children: [
            const TextSpan(
                text: "no Face detected ...",
                style: TextStyle(color: Colors.white)),
            WidgetSpan(
                child: Icon(
                  Icons.close,
                  color: Colors.red[400],
                ))
          ],
        ),
        );
      }
      case (1):{
        return Text.rich(TextSpan(
          children: [
            const TextSpan(
                text: "Face Detected ...",
                style: TextStyle(color: Colors.white)),
            WidgetSpan(
                child: Icon(Icons.done,
                    color: Colors.green[400])),
            const WidgetSpan(
                child: Icon(Icons.face,
                    color: Colors.white)),
          ],
        ));
      }
      default : {
        if (value > 1 ){
          return Text.rich(TextSpan(children: [
            const TextSpan(
                text: "More than one person detected ...",
                style: TextStyle(color: Colors.white)),
            WidgetSpan(
                child: Icon(
                  Icons.close,
                  color: Colors.red[400],
                ))
          ]));
        }
        else {
          return const SizedBox(height: 10);
        }
      }


    }
  }
}