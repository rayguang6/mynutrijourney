import 'package:flutter/material.dart';

class ProgressChartPainter extends CustomPainter {
  final double targetPercentage;
  final double currentPercentage;
  final double strokeWidth;
  final Color progressColor;

  ProgressChartPainter({
    required this.targetPercentage,
    required this.currentPercentage,
    required this.strokeWidth,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = (size.width - strokeWidth) / 2;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Draw the target progress arc
    final targetSweepAngle = 360 * (targetPercentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      -90,
      targetSweepAngle,
      false,
      progressPaint,
    );

    // Draw the current progress arc
    final currentSweepAngle = 360 * (currentPercentage / 100);
    progressPaint.color = Colors.green;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      -90,
      currentSweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}