import 'package:flutter/material.dart';
import 'dart:math';

class ForwardScreen extends StatefulWidget {
  const ForwardScreen({Key? key}) : super(key: key);

  @override
  State<ForwardScreen> createState() => _ForwardState();
}

class _ForwardState extends State<ForwardScreen> {
  double _currentValue = 0.0;
  final sliderMax = 100.0;
  final sliderDiv = 5.0;


  String makeTextStr() {
    return 'Forward ${_currentValue.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Move forward')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              makeTextStr(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            RotatedBox(
              quarterTurns: 3,
              child:
              SizedBox(
                width: 250,
                height: 250,
                child: Slider(
                  value: _currentValue,
                  max: sliderMax,
                  divisions: (sliderMax / sliderDiv).round(),
                  label: _currentValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                        _currentValue = value;
                    });
            }))),
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

