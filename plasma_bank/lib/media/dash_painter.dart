


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    double origin_x = 0.0;
    double count = (size.width / 10.0);
    for(int i = 0; i < count; i++){
      canvas.drawLine(Offset(origin_x, 0.0), Offset(origin_x+5, 0.0), line);
      origin_x += 10;
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}