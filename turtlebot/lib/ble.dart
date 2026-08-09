import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class SimpleBle {
  final flutterReactiveBle = FlutterReactiveBle();
  StreamSubscription<DiscoveredDevice>? _scanSubscription = null;
  StreamSubscription<ConnectionStateUpdate>? _stateSub = null;
  bool _connected = false;
  String? ble_id = null;

  void connect() {
    if (_stateSub == null && _scanSubscription == null) {
      _scanSubscription = flutterReactiveBle.scanForDevices(
        withServices: [], scanMode: ScanMode.lowLatency).listen((device) {
          if (device.name.contains('turtle')) {
            print('Found device: ${device}');
            ble_id = device.id;
            _scanSubscription?.cancel();
            _scanSubscription = null;

            // Now let's connect
            _stateSub = flutterReactiveBle.connectToDevice(
              id: ble_id!,
              servicesWithCharacteristicsToDiscover: {},
              connectionTimeout: const Duration(seconds: 2),
            ).listen((state) {
                if (state.connectionState == .connected) {
                  print('CONNECTED!!');
                  // now update the MTU
                  flutterReactiveBle.requestMtu(deviceId: ble_id!, mtu: 500).then((mtu) {
                      print('Got MTU: ${mtu}');
                      _connected = true;
                  });
                } else if (state.connectionState == .disconnected) {
                  _connected = false;
                  ble_id = null;
                  _stateSub?.cancel();
                  _stateSub = null;
                } else {
                  print('Conn update: ${state}');
                }
              }, onError: (error) {
                print('Conn error: ${error}');
                _connected = false;
                _stateSub?.cancel();
                _stateSub = null;
            });
          }
        }, onError: (e) {
          print('Error: ${e}');
      });
    }
  }

  bool connected() {
    return _connected && ble_id != null;
  }

  void disconnect() {
    print('Disconnecting');
    _stateSub?.cancel();
    _stateSub = null;
  }

  void stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
  }

  final serviceUuid = Uuid.parse("6E400001-B5A3-F393-E0A9-E50E24DCCA9E");
  final characteristicUuid = Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e");

  void send(List<int> data) {
    final char = QualifiedCharacteristic(
      serviceId: serviceUuid,
      characteristicId: characteristicUuid,
      deviceId: ble_id!,
    );

    print('writing: ${char}');

    flutterReactiveBle.writeCharacteristicWithoutResponse(
      char, value: data).whenComplete(() {
        print('LOGO PROGRAM SENT');
    });
  }
}
