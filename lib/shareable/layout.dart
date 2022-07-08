import 'dart:math' as math;
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  final  Widget child ;
  const Layout ({required Key key , required this.child }): super(key : key);

  @override
  LayoutState createState() => LayoutState();
}


class LayoutState extends State<Layout> with TickerProviderStateMixin {

  final double topPolygonSize = 270,
      curvedBackgroundRadius = 100 ,
      curvedBackgroundTopPosition = 80,
      curvedBackgroundAngle = 31;
  late double curvedBackgroundLeftPosition;




  @override
  void initState() {
    super.initState();
    curvedBackgroundLeftPosition =  (math.sqrt(math.pow(100, 2) + math.pow(100, 2))) -
        curvedBackgroundRadius;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0XFF313131),
      body: Stack(
          children: <Widget>[
            _curvedBackContainer(const Color(0XFF2a2a2a), curvedBackgroundTopPosition - 10, curvedBackgroundLeftPosition - 2),
            _curvedBackContainer(const Color(0XFF232323), curvedBackgroundTopPosition, curvedBackgroundLeftPosition),
            _backgroundContainer(),

            Container(
                child: widget.child,
              ),
          ],
        ),
      );
  }



  _curvedBackContainer(Color color, double topPosition, double leftPosition) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Positioned(
      top: topPosition,
      left: leftPosition,
      child: Transform.rotate(
        angle: _degreesToRadian(curvedBackgroundAngle),
        alignment: FractionalOffset.topLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.all(Radius.circular(curvedBackgroundRadius)),
            color: color,
          ),
          width: deviceWidth / math.cos(_degreesToRadian(curvedBackgroundAngle)),
          //width:  MediaQuery.of(context).size.width,
          height:
          math.sqrt(math.pow(deviceWidth, 2) + math.pow(deviceWidth, 2)),
        ),
      ),
    );
  }

  _backgroundContainer() {
    double deviceWidth = MediaQuery.of(context).size.width;
    double backgroundTopMargin = curvedBackgroundTopPosition + (deviceWidth * math.tan(_degreesToRadian(curvedBackgroundAngle)));
    return Padding(
      padding: EdgeInsets.only(top: backgroundTopMargin),
      child: Container(
        color: const Color(0XFF232323),
      ),
    );
  }
  double _degreesToRadian(double degrees){
    return degrees * math.pi / 180;
  }
}
