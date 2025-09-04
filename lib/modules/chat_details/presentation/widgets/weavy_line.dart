import 'package:flutter/material.dart';

class WavyLine extends StatelessWidget {
  const WavyLine({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: WavyLinePainter(context));
  }
}

class WavyLinePainter extends CustomPainter {
  final BuildContext context;
  WavyLinePainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Theme.of(context).colorScheme.primary
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();
    const waveHeight = 5.0;
    const waveLength = 11.0;

    path.moveTo(0, size.height / 2);

    for (double i = 0; i < size.width; i += waveLength) {
      path.quadraticBezierTo(
        i + waveLength / 4,
        size.height / 2 - waveHeight / 2,
        i + waveLength / 2,
        size.height / 2,
      );
      path.quadraticBezierTo(
        i + 3 * waveLength / 4,
        size.height / 2 + waveHeight / 2,
        i + waveLength,
        size.height / 2,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
