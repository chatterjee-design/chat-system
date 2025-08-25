import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/chat_search_provider.dart';
import '../widgets/search_chat_widget.dart';
import '../widgets/search_result_widget.dart';

class ChatSearchScreen extends StatelessWidget {
  const ChatSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatSearchProvider(),
      child: const _ChatSearchBody(),
    );
  }
}

class _ChatSearchBody extends StatelessWidget {
  const _ChatSearchBody();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatSearchProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leadingWidth: 55,

        title: SearchChatWidget(provider: provider),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text("Date"),
                  onSelected: (_) => _showDateFilter(context, provider),
                ),
                FilterChip(
                  label: const Text("Attachment"),
                  onSelected: (_) => _showAttachmentFilter(context, provider),
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

          Expanded(
            child: provider.hasSearchedOrFiltered
                ? SearchResult(provider: provider)
                : const Center(
                    child: Text(
                      "No results yet. Start searching or apply a filter.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showDateFilter(BuildContext context, ChatSearchProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: DateFilter.values.map((f) {
          return ListTile(
            title: Text(f.toString().split('.').last),
            onTap: () {
              provider.updateDateFilter(f);
              Navigator.pop(ctx);
            },
          );
        }).toList(),
      ),
    );
  }

  void _showAttachmentFilter(
    BuildContext context,
    ChatSearchProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Image"),
            onTap: () {
              provider.updateAttachmentFilter(AttachmentFilter.image);
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            title: const Text("PDF"),
            onTap: () {
              provider.updateAttachmentFilter(AttachmentFilter.pdf);
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            title: const Text("Document"),
            onTap: () {
              provider.updateAttachmentFilter(AttachmentFilter.document);
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            title: const Text("Clear"),
            onTap: () {
              provider.updateAttachmentFilter(AttachmentFilter.none);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}
