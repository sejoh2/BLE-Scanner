// lib/models/ble_device.dart
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEDevice {
  final BluetoothDevice device;
  final int rssi;
  final String name;

  BLEDevice({required this.device, required this.rssi, required this.name});
}
