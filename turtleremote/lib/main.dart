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
  double _currentValue = 10.0;
  
  @override
  Widget build(BuildContext context) {
    const sliderMax = 100.0;
    
    return MaterialApp(
      home: Scaffold(
        body: SafeArea( child: Row(
            children: [
              SizedBox(width: 20),
              Column(
                children: [
                  SizedBox(height: 20),
                  Text('Servo: ${_currentValue.round()}'),
                  Expanded(child: RotatedBox(
                    quarterTurns: 3,
                    child: Slider(
                      value: _currentValue,
                      max: sliderMax,
                      label: _currentValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                            _currentValue = value;
                        });
              })))]),
              Text('Hello Horizontal!'),
    ]))));
}}
