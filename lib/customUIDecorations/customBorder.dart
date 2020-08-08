import 'package:flutter/material.dart';

class MyCustomShapeBorder extends ShapeBorder {
  final double borderThickness;
  final Color borderColor;
  final double padding;

  MyCustomShapeBorder(this.borderThickness, this.borderColor, this.padding);
  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.symmetric(horizontal: borderThickness);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return null;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    // canvas.drawPath(
    //   getOuterPath(rect),
    //   Paint()
    //     ..color = borderColor
    //     ..strokeWidth = borderThickness,
    // );
    // canvas.drawCircle(
    //   Offset.zero,
    //   14,
    //   Paint()
    //     ..color = borderColor
    //     ..strokeWidth = borderThickness,
    // );
    Paint paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderThickness
      ..style = PaintingStyle.stroke;
    double gap = 30;
    canvas.drawLine(rect.topLeft + Offset(gap, -padding),
        rect.topRight - Offset(gap, padding), paint);

    canvas.drawLine(rect.bottomLeft + Offset(gap, padding),
        rect.bottomRight - Offset(gap, -padding), paint);
  }

  @override
  ShapeBorder scale(double t) {
    return this;
  }
}
