import 'package:flutter/material.dart';

import '../../../../core/font/app_font.dart';
import '../../../../provider/chat_search_provider.dart';
import '../../../../utils/time_formater.dart';
import '../../widgets/subtilte_search_body.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({super.key, required this.provider});

  final ChatSearchProvider provider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: provider.filteredMessages.length,
      itemBuilder: (context, index) {
        final msg = provider.filteredMessages[index];

        return Column(
          children: [
            ListTile(
              minTileHeight: 0,
              contentPadding: EdgeInsets.all(10),
              isThreeLine: true,

              titleAlignment: ListTileTitleAlignment.titleHeight,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(msg["avatar"]),
              ),
              title: Text(
                msg["name"] ?? " ",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AppFormatedTime.formattedTimestamp(msg['timestamp']),
                    style: appText(size: 10, weight: FontWeight.w400),
                  ),
                ],
              ),
              subtitle: buildMessageSubtitle(msg, provider.query),
            ),
            const Divider(thickness: 0.5, height: 1),
          ],
        );
      },
    );
  }
}
