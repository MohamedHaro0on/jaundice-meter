// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';

class Button extends StatefulWidget {
  late final Widget child;
  dynamic onButtonClick, tooltip;
  Color backgroundColor;
  final double? size;
  final String? heroTag;

  Button(
      {required Key key,
      required this.child,
      required this.onButtonClick,
      required this.backgroundColor,
      this.tooltip,
      this.size,
      this.heroTag})
      : super(key: key);

  @override
  ButtonState createState() => ButtonState();
}

class ButtonState extends State<Button> {
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
    return (SizedBox(
      height: widget.size!,
      width: widget.size!,
      child: FittedBox(
        fit: BoxFit.cover,
        child: FloatingActionButton(
            backgroundColor: widget.backgroundColor,
            tooltip: widget.tooltip!,
            heroTag: widget.heroTag,
            shape: const PolygonBorder(
              sides: 6,
              borderRadius: 10.0,
            ),
            onPressed: widget.onButtonClick,
            child: widget.child),
      ),
    ));
  }
}
