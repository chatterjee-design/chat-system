import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/font/app_font.dart';
import '../../../../provider/star_chat_provider.dart';
import '../../../../utils/time_formater.dart';
import '../widgets/message_tile.dart';

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
                        contentPadding: EdgeInsets.zero,
                        // isThreeLine: ,
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(msg["avatar"]),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                msg["name"],
                                style: appText(
                                  size: 14,
                                  weight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              AppFormatedTime.smartTimestamp(msg['timestamp']),
                              style: appText(size: 9, weight: FontWeight.w400),
                            ),
                          ],
                        ),
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
