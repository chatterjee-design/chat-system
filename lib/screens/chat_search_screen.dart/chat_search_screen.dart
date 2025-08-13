import 'package:flutter/material.dart';

class ChatSearchScreen extends StatelessWidget {
  const ChatSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.grey[200],
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                ],
              ),
            ),

            // Filter chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Wrap(
                spacing: 8,
                children: [
                  FilterChip(label: const Text("From"), onSelected: (_) {}),
                  FilterChip(
                    label: const Text("Said in Soumajit Das"),
                    onSelected: (_) {},
                  ),
                  FilterChip(
                    label: const Text("Attachment"),
                    onSelected: (_) {},
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                "Most relevant",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),

            // Results list
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://via.placeholder.com/150",
                      ), // Replace with avatar
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Soumajit Das",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "6 Aug 12:42 pm",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    subtitle: _HighlightedText(
                      text: "You: Hii",
                      highlight: "Hi",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightedText extends StatelessWidget {
  final String text;
  final String highlight;

  const _HighlightedText({required this.text, required this.highlight});

  @override
  Widget build(BuildContext context) {
    final parts = text.split(highlight);
    return RichText(
      text: TextSpan(
        children: [
          for (int i = 0; i < parts.length; i++) ...[
            TextSpan(
              text: parts[i],
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            if (i < parts.length - 1)
              TextSpan(
                text: highlight,
                style: const TextStyle(
                  backgroundColor: Colors.yellow,
                  color: Colors.black,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
