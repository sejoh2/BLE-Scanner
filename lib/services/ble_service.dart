// lib/services/ble_service.dart
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/ble_device.dart';

class BLEService {
  // Singleton
  static final BLEService _instance = BLEService._internal();
  factory BLEService() => _instance;
  BLEService._internal();

  // Stream of scanned devices
  Stream<List<BLEDevice>> scanResults() {
    return FlutterBluePlus.scanResults.map((results) {
      return results.map((r) {
        // Get device name info
        String platformName = r.device.platformName;
        String advName = r.advertisementData.advName;
        String mac = r.device.id.id;
        int rssi = r.rssi;

        // Print device details
        print('--- BLE Device Found ---');
        print('Platform Name: $platformName');
        print('Advertised Name: $advName');
        print('MAC Address: $mac');
        print('RSSI: $rssi');
        print('------------------------');

        // Determine display name
        String name = r.device.name.isNotEmpty
            ? r.device.name
            : r.advertisementData.advName.isNotEmpty
            ? r.advertisementData.advName
            : "Unknown Device";

        print('Device Name: ${r.device.name}');

        return BLEDevice(device: r.device, rssi: r.rssi, name: name);
      }).toList();
    });
  }

  // Start scanning
  Future<void> startScan() async {
    await FlutterBluePlus.startScan(); // runs continuously until stopScan() is called
  }

  // Stop scanning
  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  // Discover services
  Future<List<BluetoothService>> discoverServices(
    BluetoothDevice device,
  ) async {
    return await device.discoverServices();
  }

  // Device connection state
  Stream<BluetoothConnectionState> deviceState(BluetoothDevice device) {
    return device.connectionState;
  }

  // Stream of Bluetooth adapter state
  Stream<BluetoothAdapterState> get bluetoothState =>
      FlutterBluePlus.adapterState;
}
