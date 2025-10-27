import 'package:flutter/material.dart';

class FilterTile extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;
  const FilterTile({
    super.key,
    required this.text,
    this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(width: 5),

            if (icon != null) ...[Icon(icon, size: 16, color: Colors.black54)],
          ],
        ),
      ),
    );
  }
}
