import 'package:flutter/material.dart';

class HalfBorderCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path line = Path();
    line.moveTo(size.width / 4, 0);
    line.lineTo(size.width * 0.75, 0);
    line.moveTo(size.width / 4, size.height);
    line.lineTo(size.width * 0.75, size.height);
    return line;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
