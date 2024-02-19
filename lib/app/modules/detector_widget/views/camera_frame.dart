import 'package:flutter/material.dart';

class CameraFramePainter extends CustomPainter {
  final Color frameColor;

  CameraFramePainter(this.frameColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = frameColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
