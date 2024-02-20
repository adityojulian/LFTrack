import 'package:flutter/material.dart';

class CameraFramePainter extends CustomPainter {
  final Color frameColor;

  CameraFramePainter(this.frameColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = frameColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, paint);

    final stroke = Paint()
      ..color = frameColor
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Offset.zero & size, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// class FocusFrameOverlay extends StatelessWidget {
//   final Color backgroundColor;
//   final Rect frameRect;

//   const FocusFrameOverlay({
//     Key? key,
//     this.backgroundColor =
//         const Color.fromRGBO(0, 0, 0, 0.8), // Semi-transparent black
//     required this.frameRect, // The rect of the frame where you want the focus
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: _FocusFramePainter(
//           backgroundColor: backgroundColor, frameRect: frameRect),
//       size: MediaQuery.of(context).size,
//     );
//   }
// }

// class _FocusFramePainter extends CustomPainter {
//   final Color backgroundColor;
//   final Rect frameRect;

//   _FocusFramePainter({required this.backgroundColor, required this.frameRect});

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Paint the whole screen with the overlay color
//     canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
//         Paint()..color = backgroundColor);

//     // Clear the frame area
//     Paint clearPaint = Paint();
//     clearPaint.blendMode = BlendMode.src;
//     clearPaint.color = backgroundColor.withOpacity(0.1);

//     canvas.drawRect(
//         frameRect, Paint()..color = const Color.fromRGBO(255, 255, 255, 0.2));
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
