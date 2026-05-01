import 'package:flutter/material.dart';

class RideShareLogo extends StatelessWidget {
  final double size;
  final Color? primaryColor;
  final Color? accentColor;

  const RideShareLogo({
    super.key,
    this.size = 100,
    this.primaryColor,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = primaryColor ?? Colors.deepPurple;
    final accent = accentColor ?? Colors.cyan;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primary, primary.withValues(alpha: 0.7)],
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          // Car icon
          CustomPaint(
            size: Size(size * 0.6, size * 0.6),
            painter: CarPainter(color: accent),
          ),
          // Pin icon on top
          Positioned(
            top: size * 0.1,
            right: size * 0.1,
            child: Container(
              width: size * 0.2,
              height: size * 0.2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Icons.location_on, color: primary, size: size * 0.12),
            ),
          ),
        ],
      ),
    );
  }
}

class CarPainter extends CustomPainter {
  final Color color;

  CarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Car body
    final bodyPath = Path();
    bodyPath.moveTo(size.width * 0.2, size.height * 0.5);
    bodyPath.lineTo(size.width * 0.3, size.height * 0.3);
    bodyPath.lineTo(size.width * 0.7, size.height * 0.3);
    bodyPath.lineTo(size.width * 0.8, size.height * 0.5);
    bodyPath.lineTo(size.width * 0.8, size.height * 0.65);
    bodyPath.lineTo(size.width * 0.2, size.height * 0.65);
    bodyPath.close();

    canvas.drawPath(bodyPath, fillPaint);

    // Windows
    final windowPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    Rect window1 = Rect.fromLTWH(
      size.width * 0.35,
      size.height * 0.35,
      size.width * 0.2,
      size.height * 0.15,
    );
    canvas.drawRect(window1, windowPaint);

    Rect window2 = Rect.fromLTWH(
      size.width * 0.6,
      size.height * 0.35,
      size.width * 0.15,
      size.height * 0.15,
    );
    canvas.drawRect(window2, windowPaint);

    // Wheels
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.72),
      size.width * 0.12,
      fillPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.72),
      size.width * 0.12,
      fillPaint,
    );

    // Wheel details
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.72),
      size.width * 0.06,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.72),
      size.width * 0.06,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(CarPainter oldDelegate) => false;
}
