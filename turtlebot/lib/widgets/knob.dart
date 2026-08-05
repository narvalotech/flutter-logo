import 'package:flutter/material.dart';
import 'dart:math';

class Knob extends StatefulWidget {
  final ValueChanged<double> onChanged;

  const Knob({Key? key, required this.onChanged}) : super(key: key);

  @override
  _KnobState createState() => _KnobState();
}

class _KnobState extends State<Knob> {
  double _angle = 0.0;
  double _displayAngle = 0.0;
  double _lastPanAngle = 0.0;

  double readAngle(Offset position, BoxConstraints constraints) {
    Offset center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
    return atan2(position.dy - center.dy, position.dx - center.dx) + (pi / 2);
  }

  void _onPanStart(DragStartDetails details, BoxConstraints constraints) {
    _lastPanAngle = readAngle(details.localPosition, constraints);
  }

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    Offset center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
    double radius = min(constraints.maxWidth, constraints.maxHeight) / 2;
    double distance = (details.localPosition - center).distance;

    double panAngle = readAngle(details.localPosition, constraints);
    double delta = panAngle - _lastPanAngle;

    if (delta > pi) {
      delta -= 2 * pi;
    } else if (delta < -pi) {
      delta += 2 * pi;
    }

    double lastAngle = _displayAngle;
    _angle += delta;

    if (distance > radius) {
      double snap = 15 * (pi / 180);
      _displayAngle = (_angle / snap).round() * snap;
    } else {
      _displayAngle = _angle;
    }

    _angle = _angle % (2 * pi);
    _lastPanAngle = panAngle;

    if (lastAngle != _displayAngle) {
      setState(() {});
      widget.onChanged(_displayAngle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanStart: (details) => _onPanStart(details, constraints),
          onPanUpdate: (details) => _onPanUpdate(details, constraints),
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: DialPainter(angle: _displayAngle,
              bgColor: colorScheme.surfaceContainerHighest,
              fgColor: colorScheme.outline,
              accentColor: colorScheme.primary,
            ),
          ),
        );
      }
    );
  }
}

class DialPainter extends CustomPainter {
  final double angle;
  final Color bgColor;
  final Color fgColor;
  final Color accentColor;

  DialPainter({required this.angle,
      required this.bgColor,
      required this.fgColor,
      required this.accentColor,
  });

  Paint makeBackground(Color shade) {
    Paint bg = Paint()
    ..color = shade
    ..style = PaintingStyle.fill;
    return bg;
  }

  Paint makeOutline(Color shade) {
    Paint outline = Paint()
    ..color = shade
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0;
    return outline;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width, size.height) / 2;

    { // Dial
      canvas.drawCircle(center, radius, makeBackground(bgColor));
      canvas.drawCircle(center, radius, makeOutline(fgColor));
    }

    { // Knob
      double drawAngle = angle - (pi / 2);
      const double offsetRatio = 0.75;
      double indicatorX = center.dx + (radius * offsetRatio) * cos(drawAngle);
      double indicatorY = center.dy + (radius * offsetRatio) * sin(drawAngle);

      canvas.drawCircle(Offset(indicatorX, indicatorY), radius * 0.15, makeBackground(fgColor));
      canvas.drawCircle(Offset(indicatorX, indicatorY), radius * 0.15, makeOutline(accentColor));
    }
  }

  @override
  bool shouldRepaint(covariant DialPainter oldDelegate) {
    // Only repaint if the angle has actually changed
    return oldDelegate.angle != angle;
  }
}
