// lib/providers/ble_provider.dart
import 'package:flutter/material.dart';
import '../services/ble_service.dart';
import '../models/ble_device.dart';
import 'package:permission_handler/permission_handler.dart';

class BLEProvider extends ChangeNotifier {
  final BLEService _bleService = BLEService();

  bool isScanning = false;
  List<BLEDevice> devices = [];

  // Start scanning (persistent)
  Future<void> startScan() async {
    if (isScanning) return;
    isScanning = true;
    devices = [];
    notifyListeners();

    // Request necessary permissions
    var status = await Permission.bluetoothScan.request();
    var statusConnect = await Permission.bluetoothConnect.request();
    var statusLocation = await Permission.locationWhenInUse.request();

    if (!status.isGranted ||
        !statusConnect.isGranted ||
        !statusLocation.isGranted) {
      isScanning = false;
      notifyListeners();
      return;
    }

    // Start scanning
    await _bleService.startScan(); // continuous scan

    _bleService
        .scanResults()
        .listen((foundDevices) {
          devices = foundDevices;

          for (var device in devices) {
            print(
              'Found Device: ${device.name}, MAC: ${device.device.id.id}, RSSI: ${device.rssi}',
            );
          }

          notifyListeners();
        })
        .onDone(() {
          isScanning = false;
          notifyListeners();
        });
  }

  // Stop scanning
  Future<void> stopScan() async {
    isScanning = false;
    notifyListeners();
    await BLEService().stopScan(); // make sure this returns Future<void>
  }
}
