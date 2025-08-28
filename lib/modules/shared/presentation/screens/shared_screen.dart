import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/shared_items_provider.dart';
import '../../../../utils/time_formater.dart';
import 'shared_details_screen.dart';

class SharedScreen extends StatelessWidget {
  const SharedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SharedItemsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Shared")),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          _buildSection(
            context,
            "Files",
            provider.files,
            (msg) => ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 2,
              ),
              minLeadingWidth: 70,
              horizontalTitleGap: 10,
              leading: SizedBox(
                width: 70,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 0,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(msg['avatar']),
                      ),
                    ),
                    const Positioned(
                      right: 0,
                      child: CircleAvatar(child: Icon(Icons.picture_as_pdf)),
                    ),
                  ],
                ),
              ),
              title: Text(msg["content"].toString().split("/").last),
              subtitle: Row(
                children: [
                  const Icon(
                    Icons.person_4_outlined,
                    size: 15,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${msg["name"]} • ${AppFormatedTime.formattedTimestamp(msg['timestamp'])}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              trailing: const Icon(Icons.more_vert),
            ),
          ),
          _buildSection(
            context,
            "Links",
            provider.links,
            (msg) => ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 2,
              ),
              minLeadingWidth: 70,
              horizontalTitleGap: 10,
              leading: SizedBox(
                width: 70,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 0,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(msg['avatar']),
                      ),
                    ),
                    const Positioned(
                      right: 0,
                      child: CircleAvatar(child: Icon(Icons.link)),
                    ),
                  ],
                ),
              ),
              title: Text(
                msg["content"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Row(
                children: [
                  const Icon(
                    Icons.person_4_outlined,
                    size: 15,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${msg["name"]} • ${AppFormatedTime.formattedTimestamp(msg['timestamp'])}",
                    style: const TextStyle(
                      fontSize: 12, // 👈 smaller
                      color: Colors.grey, // optional subtle look
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.more_vert),
            ),
          ),

          _buildSection(
            context,
            "Media",
            provider.media,

            isGrid: true,
            (msg) => SizedBox(
              height: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(msg["content"], fit: BoxFit.cover),
                    ),
                    Positioned(
                      left: 6,
                      top: 6,
                      // bottom: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(msg['avatar']),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> items,
    Widget Function(Map<String, dynamic>) builder, {
    bool isGrid = false,
    int previewCount = 3,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SharedDetailScreen(
                      title: title,
                      items: items,
                      builder: builder,
                      isGrid: isGrid,
                    ),
                  ),
                );
              },
              child: const Text("View all"),
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (isGrid)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.take(6).length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemBuilder: (_, i) => builder(items[i]),
          )
        else
          Column(children: items.take(previewCount).map(builder).toList()),
        const SizedBox(height: 12),
      ],
    );
  }
}
