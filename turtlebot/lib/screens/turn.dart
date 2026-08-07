import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/knob.dart';

class TurnScreen extends StatefulWidget {
  const TurnScreen({Key? key}) : super(key: key);

  @override
  State<TurnScreen> createState() => _TurnState();
}

enum Direction {
  left, right;

  @override
  String toString() {
    return name[0].toUpperCase() + name.substring(1);
  }
}

class _TurnState extends State<TurnScreen> {
  double _currentValue = 0.0;

  String makeTextStr() {
    double directionalAngle = 0.0;
    Direction dir;

    if (_currentValue > 180) {
      directionalAngle = (360 - _currentValue);
      dir = Direction.left;
    } else {
      directionalAngle = _currentValue;
      dir = Direction.right;
    }

    return 'Turn ${directionalAngle.toStringAsFixed(0)} degrees ${dir}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Turn left or right')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              makeTextStr(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            SizedBox(
              width: 250,
              height: 250,
              child: Knob(
                onChanged: (angle) {
                  setState(() => {_currentValue = angle * 180 / pi});
                })),
            const SizedBox(height: 40),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.filledTonal(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.clear, size: 50.0),
                    tooltip: 'Back',
                  ),
                  IconButton.filledTonal(
                    onPressed: () {
                      Navigator.pop(context, _currentValue);
                    },
                    icon: const Icon(Icons.check, size: 50.0),
                    tooltip: 'OK',
                  ),
              ])
          ])));
}}

