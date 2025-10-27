import 'package:bleconnect/components/expansion_tile.dart';
import 'package:bleconnect/components/my_button.dart';
import 'package:bleconnect/components/signal_strength_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  bool isConnecting = false;
  bool isConnected = false;
  BluetoothDevice? device;
  List<BluetoothService> services = [];

  void toggleConnection() async {
    if (device == null) return;

    setState(() => isConnecting = true);

    try {
      if (isConnected) {
        await device!.disconnect();
        setState(() {
          isConnected = false;
          services = [];
        });
      } else {
        // Make sure device is not already connected
        if (device!.state == BluetoothDeviceState.connected) {
          await device!.disconnect();
        }

        await device!.connect(
          autoConnect: false,
          license: License.free,
          timeout: Duration(seconds: 30),
        );

        setState(() => isConnected = true);

        // ✅ Request MTU after connection
        try {
          await device!.requestMtu(512); // adjust value as needed
          print('MTU requested successfully');
        } catch (e) {
          print('MTU request failed: $e');
        }

        // Discover services
        services = await device!.discoverServices();
        setState(() {});
      }
    } catch (e) {
      print('Connection error: $e');

      String errorMessage;

      if (e.toString().contains('timeout')) {
        errorMessage =
            'Connection timed out. Please move closer and try again.';
      } else if (e.toString().contains('already connected')) {
        errorMessage = 'This device is already connected.';
      } else if (e.toString().contains('disconnected')) {
        errorMessage = 'Device disconnected unexpectedly.';
      } else {
        errorMessage = 'Failed to connect. Please try again.';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() => isConnecting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Receive the arguments from the previous page
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final String devicename = args['devicename'];
    final String macaddress = args['macaddress'];
    final String signalstrength = args['signalstrength'];
    final IconData icon = args['icon'];
    device = args['device']; // The real BluetoothDevice

    int rssiValue = int.tryParse(signalstrength.replaceAll(' dBm', '')) ?? -100;

    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(title: Center(child: Text('Connect to $devicename'))),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 70),

                  const SizedBox(height: 10),

                  Text(devicename),

                  const SizedBox(height: 10),

                  Text(macaddress),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SignalBars(rssi: rssiValue),
                      const SizedBox(width: 8),
                      Text(
                        signalstrength,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: isConnecting
                        ? CircularProgressIndicator(color: Colors.black)
                        : MyButton(
                            text: isConnected ? 'Disconnect' : 'Connect',
                            onTap: toggleConnection,
                          ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isConnecting
                        ? 'Connecting...'
                        : isConnected
                        ? 'Connected'
                        : 'Disconnected',
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: services.isEmpty
                  ? Center(
                      child: Text(
                        'No Services Or Characteristics Found!',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView(
                      children: services.map((service) {
                        // Convert characteristics to Map<String, String> for your tile
                        List<Map<String, String>> chars = service
                            .characteristics
                            .map((c) {
                              return {
                                'uuid': c.uuid.toString(),
                                'properties': c.properties.toString(),
                              };
                            })
                            .toList();

                        return ServiceTile(
                          serviceUUID: service.uuid.toString(),
                          serviceDescription: 'Service',
                          characteristics: chars,
                        );
                      }).toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
