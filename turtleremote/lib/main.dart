import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      
  ]);

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainState();
}

class _MainState extends State<MainApp> {
  double _servoVal = 0.0;
  double _speedVal = 50.0;

  void _pressed(direction) {
    print('pressed: ${direction}');
  }

  void _released(direction) {
    print('released: ${direction}');
  }

  Widget makeButton(icon, text, color) {
    return SizedBox(
      height: 70,
      width: 70,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {_pressed(text);},
        onTapUp: (_) {_released(text);},
        onTapCancel: () {_released(text);},
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 40,
    ))));
  }
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bc = colorScheme.primary;

    const _servoMax = 152.0;
    const _speedMax = 100.0;

    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
    );
    
    return MaterialApp(
      home: Scaffold(
        body: SafeArea( child: Row(
            mainAxisAlignment: .spaceEvenly,
            children: [
              SizedBox(width: 20),
              Column(
                children: [
                  SizedBox(height: 20),
                  SizedBox(width: 100,
                    child: Text('Servo: ${_servoVal.round()}',
                      style: const TextStyle(fontSize: 20))),
                  Expanded(child: RotatedBox(
                      quarterTurns: 3,
                      child: Slider(
                        value: _servoVal,
                        max: _servoMax,
                        label: _servoVal.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                              _servoVal = value;
                          });
              })))]),

              Column(
                children: [
                  SizedBox(height: 20),
                  SizedBox(width: 100,
                  child: Text('Speed: ${_speedVal.round()}',
                    style: const TextStyle(fontSize: 20))),
                  Expanded(child: RotatedBox(
                      quarterTurns: 3,
                      child: Slider(
                        value: _speedVal,
                        max: _speedMax,
                        label: _speedVal.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                              _speedVal = value;
                          });
              })))]),

              SizedBox(width: 40),
              // Text('🐢🎮', style: const TextStyle(fontSize: 40)),
              SizedBox(width: 40),

              // Now draw the D-pad
              SizedBox(
                width: 240,
                height: 240,
                child: Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    makeButton(Icons.arrow_circle_left, 'left', bc),
                    Column(
                      mainAxisAlignment: .spaceEvenly,
                      children: [
                        makeButton(Icons.arrow_circle_up, 'up', bc),
                        SizedBox(height: 70),
                        makeButton(Icons.arrow_circle_down, 'down', bc),
                    ]),
                    makeButton(Icons.arrow_circle_right, 'right', bc),
              ])),
              SizedBox(width: 40),
    ]))));
}}
