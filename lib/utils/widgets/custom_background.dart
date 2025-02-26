import 'package:atd/utils/palette.dart';
import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {

  const CustomBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomPaint(
      size: Size(size.width, (size.width * 2.1546666666666665).toDouble()),
      painter: const MyCustomPainter(),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  const MyCustomPainter();

  @override
  void paint(Canvas canvas, Size size) {
    Paint yellowPaint = Paint()
      ..color = primary500
      ..style = PaintingStyle.fill;
    Paint bluePaint = Paint()
      ..color = secondary500
      ..style = PaintingStyle.fill;
    Path bluePath = Path();
    bluePath.moveTo(0, 0);
    bluePath.lineTo(size.width, 0);
    bluePath.lineTo(size.width, size.height);
    bluePath.lineTo(0, size.height);
    //bluePath.lineTo(0, size.height);
    bluePath.close();
    canvas.drawPath(bluePath, bluePaint);

    Path yellowPath = Path();
    yellowPath.moveTo(0, size.height * 0.9);
    yellowPath.lineTo(size.width, size.height * 0.5);
    yellowPath.lineTo(size.width, size.height);
    yellowPath.lineTo(0, size.height);
    yellowPath.close();
    canvas.drawPath(yellowPath, yellowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
