import 'package:bleconnect/components/device_tile.dart';
import 'package:bleconnect/components/filter_tile.dart';
import 'package:bleconnect/components/my_button.dart';
import 'package:bleconnect/services/ble_provider.dart';
import 'package:bleconnect/services/ble_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isBluetoothOn = false;
  String selectedFilter = 'All';
  bool isScanning = false;

  @override
  void initState() {
    super.initState();

    BLEService().bluetoothState.listen((state) {
      setState(() {
        isBluetoothOn = state == BluetoothState.on;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bleProvider = context.watch<BLEProvider>();

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        centerTitle: true,
        title: Text('BLE Connect'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.bluetooth,
                  color: isBluetoothOn ? Colors.blue : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  isBluetoothOn ? 'Bluetooth ON' : 'Bluetooth OFF',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isBluetoothOn ? Colors.green : Colors.red,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: isBluetoothOn,
                  activeColor: Colors.blue,
                  onChanged: (value) => setState(() => isBluetoothOn = value),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilterTile(
                    text: 'All',
                    isSelected: selectedFilter == 'All',
                    onTap: () => setState(() => selectedFilter = 'All'),
                  ),
                  FilterTile(
                    text: 'Audio Devices',
                    icon: Icons.headset,
                    isSelected: selectedFilter == 'Audio Devices',
                    onTap: () =>
                        setState(() => selectedFilter = 'Audio Devices'),
                  ),
                  FilterTile(
                    text: 'Smart Watches',
                    icon: Icons.watch,
                    isSelected: selectedFilter == 'Smart Watches',
                    onTap: () =>
                        setState(() => selectedFilter = 'Smart Watches'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: bleProvider.devices.isEmpty
                  ? Center(child: Text('No devices found'))
                  : ListView.separated(
                      itemCount: bleProvider.devices.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final device = bleProvider.devices[index];

                        // Apply your filter
                        if (selectedFilter == 'Audio Devices' &&
                            !device.name.toLowerCase().contains('buds'))
                          return SizedBox();
                        if (selectedFilter == 'Smart Watches' &&
                            !device.name.toLowerCase().contains('watch'))
                          return SizedBox();

                        return DeviceTile(
                          icon: Icons.devices,
                          devicename: device.name,
                          macaddress: device.device.id.id,
                          signalstrength: '${device.rssi} dBm',
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/connect',
                              arguments: {
                                'devicename': device.name,
                                'macaddress': device.device.id.id,
                                'signalstrength': '${device.rssi} dBm',
                                'device': device.device,
                                'icon': Icons.devices,
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
            MyButton(
              text: bleProvider.isScanning ? 'Stop Scan' : 'Start Scan',
              onTap: () {
                if (!isBluetoothOn) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please turn on Bluetooth to scan devices'),
                    ),
                  );
                  return;
                }

                if (bleProvider.isScanning) {
                  bleProvider.stopScan();
                } else {
                  bleProvider.startScan();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
