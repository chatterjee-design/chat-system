import 'package:chat_system/widgets/image_content_widget.dart';
import 'package:chat_system/widgets/text_with_links_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/star_chat_provider.dart';
import '../../../pdf_viewer/pdf_viewer.dart';

class StarredMsgScreen extends StatelessWidget {
  const StarredMsgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        title: const Text("Starred"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _StarredSection(
              title: "Starred messages",
              emptyTitle: "No starred messages yet",
              emptySubtitle:
                  "Your starred messages are displayed here for everyone to access.",
            ),

            const SizedBox(height: 12),

            _StarredSection(
              isResource: true,
              title: "Starred resources",
              emptyTitle: "No starred resources yet",
              emptySubtitle:
                  "Contribute important items here to highlight key resources.",
            ),
          ],
        ),
      ),
    );
  }
}

class _StarredSection extends StatelessWidget {
  final String title;
  final bool isResource;
  final String emptyTitle;
  final String emptySubtitle;

  const _StarredSection({
    required this.title,
    required this.emptyTitle,
    this.isResource = false,
    required this.emptySubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.all(16),
        children: [
          Consumer<StarChatProvider>(
            builder: (context, provider, child) {
              final starredTextMsgs = provider.textMessages;
              final starredResourceMsgs = provider.resourceMessages;

              final hasData =
                  starredTextMsgs.isNotEmpty || starredResourceMsgs.isNotEmpty;

              if (!hasData) {
                // ✅ Empty state UI
                return Column(
                  children: [
                    Image.network(
                      "https://cdn-icons-png.flaticon.com/512/7486/7486742.png",
                      height: 120,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      emptyTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      emptySubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  if (!isResource)
                    ...starredTextMsgs.map(
                      (msg) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(msg["avatar"]),
                        ),
                        title: Text(msg["name"]),
                        subtitle: Text(msg["content"]),
                      ),
                    ),

                  if (isResource)
                    ...starredResourceMsgs.map((msg) => MessageTile(msg: msg)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final Map<String, dynamic> msg;

  const MessageTile({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    final String avatar = msg["avatar"];
    final String name = msg["name"];
    final String? type = msg["type"];
    final String? content = msg["content"];
    final String? timestamp = msg["timestamp"];

    Widget? subtitleWidget;

    if (type == "image" && content != null) {
      subtitleWidget = Padding(
        padding: const EdgeInsets.only(top: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ImageContentWidget(imageUrl: msg['content']),
        ),
      );
    } else if (type == "text" && content != null) {
      subtitleWidget = buildTextWithLinks(
        msg['content'],
        normalColor: Theme.of(context).colorScheme.onSurface,
      );
    } else if (type == "pdf" && content != null) {
      final pdfName = Uri.parse(content).pathSegments.last;

      subtitleWidget = GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PdfViewerScreen(pdfUrl: msg['content']),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.picture_as_pdf, color: Colors.red, size: 18),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    pdfName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListTile(
      minTileHeight: 0,
      contentPadding: const EdgeInsets.all(10),
      isThreeLine: true,
      titleAlignment: ListTileTitleAlignment.titleHeight,
      leading: CircleAvatar(backgroundImage: NetworkImage(avatar)),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (type != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "Sent an ${type == "image" ? type : "atttachment"}",
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          if (subtitleWidget != null) subtitleWidget,
        ],
      ),

      trailing: timestamp != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  timestamp,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          : null,
    );
  }
}
