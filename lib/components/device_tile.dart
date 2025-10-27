import 'package:bleconnect/components/signal_strength_bar.dart';
import 'package:flutter/material.dart';

class DeviceTile extends StatelessWidget {
  final IconData? icon;
  final String devicename;
  final String macaddress;
  final String signalstrength;
  final VoidCallback onTap;
  DeviceTile({
    super.key,
    this.icon,
    required this.devicename,
    required this.macaddress,
    required this.signalstrength,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    int rssiValue = int.tryParse(signalstrength.replaceAll(' dBm', '')) ?? -100;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(devicename, style: TextStyle(fontWeight: FontWeight.w600)),
                Text(macaddress),
              ],
            ),

            Row(
              children: [
                Text(
                  ''
                  '$rssiValue dBm',
                ),

                const SizedBox(width: 5),

                SignalBars(rssi: rssiValue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
