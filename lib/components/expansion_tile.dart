import 'package:flutter/material.dart';

class ServiceTile extends StatelessWidget {
  final String serviceUUID;
  final String? serviceDescription;
  final List<Map<String, String>> characteristics;

  const ServiceTile({
    Key? key,
    required this.serviceUUID,
    this.serviceDescription,
    required this.characteristics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        // Remove default dividers from ExpansionTile
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // removes top/bottom divider
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          childrenPadding: EdgeInsets.zero,
          title: Text(
            "Service: $serviceUUID",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: serviceDescription != null
              ? Text(serviceDescription!)
              : null,
          children: characteristics.map((char) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text("Characteristic: ${char['uuid']}"),
              subtitle: Text("Properties: ${char['properties']}"),
              visualDensity: VisualDensity.compact, // optional: reduces height
            );
          }).toList(),
        ),
      ),
    );
  }
}
