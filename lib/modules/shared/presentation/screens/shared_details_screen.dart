import 'package:flutter/material.dart';

class SharedDetailScreen extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final Widget Function(Map<String, dynamic>) builder;
  final bool isGrid;

  const SharedDetailScreen({
    super.key,
    required this.title,
    required this.items,
    required this.builder,
    this.isGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDate(items);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.key, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              if (isGrid)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entry.value.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemBuilder: (_, i) => builder(entry.value[i]),
                )
              else
                Column(children: entry.value.map(builder).toList()),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupByDate(
    List<Map<String, dynamic>> items,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var msg in items) {
      final ts = DateTime.parse(msg['timestamp']);
      final dateOnly = DateTime(ts.year, ts.month, ts.day);

      String label;
      if (dateOnly == today) {
        label = "Today";
      } else if (dateOnly == yesterday) {
        label = "Yesterday";
      } else {
        label = "${_monthName(ts.month)} ${ts.year}";
      }

      grouped.putIfAbsent(label, () => []);
      grouped[label]!.add(msg);
    }

    return grouped;
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }
}
