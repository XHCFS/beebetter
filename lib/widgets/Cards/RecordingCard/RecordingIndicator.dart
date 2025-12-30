import 'package:flutter/material.dart';

class RecordingIndicator extends StatelessWidget {
  final bool isRecording;
  final List<double> amplitudes;
  final Color color;

  const RecordingIndicator({
    super.key,
    required this.isRecording,
    required this.amplitudes,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (!isRecording) return SizedBox.shrink();

    return SizedBox(
      height: 100,
      width: double.infinity,
      child: CustomPaint(
        painter: WaveformPainter(amplitudes.toList(), color),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final Color color;
  final double barWidth;
  final double spacing;
  final double epsilon;

  WaveformPainter(
      this.amplitudes,
      this.color,
      {this.barWidth = 4,
        this.spacing = 2,
        this.epsilon = 0.1}
      );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final centerY = size.height / 2;
    double x = 0;

    for (final amp in amplitudes) {
      final barHeight = amp * size.height / 2 + epsilon;

      final rect = Rect.fromLTWH(x, centerY - barHeight, barWidth, barHeight);
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(barWidth / 2));

      // top part
      canvas.drawRRect(rrect, paint);

      // bottom part
      final rectBottom = Rect.fromLTWH(x, centerY, barWidth, barHeight);
      final rrectBottom = RRect.fromRectAndRadius(rectBottom, Radius.circular(barWidth / 2));
      canvas.drawRRect(rrectBottom, paint);

      x += barWidth + spacing;
      if (x > size.width) break;
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter old) {
    return true;
  }
}

