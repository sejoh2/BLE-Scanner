import 'package:flutter/material.dart';

class SignalBars extends StatelessWidget {
  final int rssi; // e.g., -60
  const SignalBars({super.key, required this.rssi});

  int get bars {
    if (rssi >= -50) return 4;
    if (rssi >= -60) return 3;
    if (rssi >= -70) return 2;
    if (rssi >= -80) return 1;
    return 0;
  }

  Color get barColor {
    if (bars >= 3) return Colors.green;
    if (bars == 2) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(4, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 1),
          width: 4,
          height: (index < bars) ? (8.0 + index * 6) : 8,
          decoration: BoxDecoration(
            color: (index < bars) ? barColor : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
