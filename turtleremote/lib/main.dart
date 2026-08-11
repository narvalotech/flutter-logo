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
  
  @override
  Widget build(BuildContext context) {
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

              // Now draw the direction buttons
              SizedBox(
                width: 200,
                height: 200,
                child: Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: () {
                        print('pressed');
                      },
                      icon: const Icon(Icons.arrow_circle_left, size: 50.0),
                      tooltip: 'left',),
                    Column(children: [
                        IconButton.filledTonal(
                          onPressed: () {
                            print('pressed');
                          },
                          icon: const Icon(Icons.arrow_circle_up, size: 50.0),
                          tooltip: 'up',),
                        SizedBox(height: 65),
                        IconButton.filledTonal(
                          onPressed: () {
                            print('pressed');
                          },
                          icon: const Icon(Icons.arrow_circle_down, size: 50.0),
                          tooltip: 'down',),
                    ]),
                    IconButton.filledTonal(
                      onPressed: () {
                        print('pressed');
                      },
                      icon: const Icon(Icons.arrow_circle_right, size: 50.0),
                      tooltip: 'right',),
              ])),
              SizedBox(width: 40),
    ]))));
}}
