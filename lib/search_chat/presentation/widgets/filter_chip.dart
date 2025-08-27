import 'package:flutter/material.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CustomFilterChip({
    Key? key,
    required this.label,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      showCheckmark: false,
      selected: selected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text(label), const Icon(Icons.arrow_drop_down, size: 18)],
      ),
      onSelected: (_) => onTap(),
    );
  }
}
