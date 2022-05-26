import 'package:flutter/material.dart';

class drawer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // paint is the tool which we draw with
    var paint = Paint();

    paint.style = PaintingStyle.fill;
    paint.color=Colors.deepPurple;
    var path = new Path();

    path.lineTo(size.width/4, 0);
    path.quadraticBezierTo(size.width*0.35, size.height*0.5, size.width, size.height);
    path.lineTo(size.width,0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
