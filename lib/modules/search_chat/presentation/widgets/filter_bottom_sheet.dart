import 'package:flutter/material.dart';

Future<void> showFilterBottomSheet<T>({
  required BuildContext context,
  required String title,
  required T currentValue,
  required List<T> values,
  required String Function(T) labelBuilder,
  required ValueChanged<T> onSelected,
}) async {
  showModalBottomSheet(
    context: context,
    builder: (ctx) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(height: 1),
        ...values.map(
          (v) => RadioListTile<T>(
            title: Text(labelBuilder(v)),
            value: v,
            groupValue: currentValue,
            onChanged: (val) {
              if (val != null) {
                onSelected(val);
                Navigator.pop(ctx);
              }
            },
          ),
        ),
      ],
    ),
  );
}
