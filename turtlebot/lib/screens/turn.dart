import 'package:flutter/material.dart';
import 'dart:math';
import 'knob.dart';

class TurnScreen extends StatefulWidget {
  const TurnScreen({Key? key}) : super(key: key);

  @override
  State<TurnScreen> createState() => _TurnState();
}


class _TurnState extends State<TurnScreen> {
  double _currentValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Turn arouuuund')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Stuff: ${_currentValue.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            SizedBox(
              width: 250,
              height: 250,
              child: Knob(
                onChanged: (angle) {
                  setState(() => {_currentValue = angle * 180 / pi});
                }
    ))])));
}}

