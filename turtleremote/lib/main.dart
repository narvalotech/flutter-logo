import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'ble.dart';

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

enum RemoteCommand {
  Unknown(0), Forward(1), Back(2), Left(3), Right(4), Servo1(5), Servo2(6);

  final int value;

  const RemoteCommand(this.value);
}

class RemoteProtocol {
  RemoteCommand command;        // u8
  num magnitude;               // u16

  RemoteProtocol(this.command, this.magnitude);

  Uint8List serialize() {
    var buf = ByteData(3);
    buf.setInt8(0, command.value);
    buf.setInt16(1, magnitude.round() as int, Endian.little);

    return buf.buffer.asUint8List();
  }

  @override
  String toString() {
    String name = command.name.toUpperCase();
    if (magnitude != null) {
      final int m = magnitude!.round().toInt();
      return '${name} ${m}';
    }
    return name;
  }
}

class _MainState extends State<MainApp> {
  double _servoVal = 0.0;
  double _speedVal = 50.0;

  final ble = SimpleBle();

  var currentCommand = RemoteCommand.Unknown;
  Timer? commandTimer;

  void sendCommand(cmd) {
    // print('send: ${cmd} => ${cmd.serialize()}');
    ble.connect();
    ble.send(cmd.serialize());
  }

  void sendPeriodicCommand(timer) {
    if (currentCommand == .Unknown) {
      final cmd = RemoteProtocol(RemoteCommand.Forward, 0);
      sendCommand(cmd);
      return;
    }

    final cmd = RemoteProtocol(currentCommand, _speedVal);
    sendCommand(cmd);
  }

  void _pressed(direction) {
    currentCommand = direction;
    commandTimer = Timer.periodic(const Duration(milliseconds: 100), sendPeriodicCommand);
    // print('pressed: ${direction}');
  }

  void _released(direction) {
    currentCommand = RemoteCommand.Unknown;
    commandTimer?.cancel();
    final cmd = RemoteProtocol(RemoteCommand.Forward, 0);
    sendCommand(cmd);
    // print('rel: ${direction}');
  }

  Widget makeButton(icon, direction, color) {
    return SizedBox(
      height: 70,
      width: 70,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {_pressed(direction);},
        onTapUp: (_) {_released(direction);},
        onTapCancel: () {_released(direction);},
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
                  SizedBox(width: 120,
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
                              sendCommand(RemoteProtocol(RemoteCommand.Servo1, value.round()));
                          });
              })))]),

              Column(
                children: [
                  SizedBox(height: 20),
                  SizedBox(width: 120,
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
                    makeButton(Icons.arrow_circle_left, RemoteCommand.Left, bc),
                    Column(
                      mainAxisAlignment: .spaceEvenly,
                      children: [
                        makeButton(Icons.arrow_circle_up, RemoteCommand.Forward, bc),
                        SizedBox(height: 70),
                        makeButton(Icons.arrow_circle_down, RemoteCommand.Back, bc),
                    ]),
                    makeButton(Icons.arrow_circle_right, RemoteCommand.Right, bc),
              ])),
              SizedBox(width: 40),
    ]))));
}}
