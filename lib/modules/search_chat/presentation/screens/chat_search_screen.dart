import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../provider/chat_search_provider.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/filter_chip.dart';
import '../widgets/search_chat_widget.dart';
import 'components/search_result_widget.dart';

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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CustomFilterChip(
                    label: "From",
                    selected: provider.senderFilter != SenderFilter.all,
                    onTap: () => showFilterBottomSheet<SenderFilter>(
                      context: context,
                      title: "From",
                      currentValue: provider.senderFilter,
                      values: SenderFilter.values,
                      labelBuilder: (f) => f.toString().split('.').last,
                      onSelected: provider.updateSenderFilter,
                    ),
                  ),
                  const SizedBox(width: 8),

                  CustomFilterChip(
                    label: "Date",
                    selected: provider.dateFilter != DateFilter.anyTime,
                    onTap: () => showFilterBottomSheet<DateFilter>(
                      context: context,
                      title: "Date",
                      currentValue: provider.dateFilter,
                      values: DateFilter.values,
                      labelBuilder: (f) => f.toString().split('.').last,
                      onSelected: provider.updateDateFilter,
                    ),
                  ),
                  const SizedBox(width: 8),

                  CustomFilterChip(
                    label: "Has any attachment",
                    selected:
                        provider.attachmentFilter != AttachmentFilter.none &&
                        provider.attachmentFilter != AttachmentFilter.link,
                    onTap: () => showFilterBottomSheet<AttachmentFilter>(
                      context: context,
                      title: "Attachment",
                      currentValue: provider.attachmentFilter,
                      values: AttachmentFilter.values,
                      labelBuilder: (f) => f.toString().split('.').last,
                      onSelected: provider.updateAttachmentFilter,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    selected:
                        provider.attachmentFilter == AttachmentFilter.link,
                    label: const Text("Links"),
                    onSelected: (_) =>
                        provider.updateAttachmentFilter(AttachmentFilter.link),
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () => showFilterBottomSheet<SortFilter>(
              context: context,
              title: "Sort by",
              currentValue: provider.sortFilter,
              values: SortFilter.values,
              labelBuilder: (f) => f == SortFilter.mostRelevant
                  ? "Most Relevant"
                  : "Most Recent",
              onSelected: provider.updateSortFilter,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    provider.sortFilter == SortFilter.mostRelevant
                        ? "Most relevent"
                        : "Most recent",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Icon(Icons.arrow_drop_down, size: 18, color: Colors.grey),
                ],
              ),
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
}
