import 'package:flutter/material.dart';

import '../../../provider/chat_search_provider.dart';

class SearchChatWidget extends StatelessWidget {
  const SearchChatWidget({super.key, required this.provider});

  final ChatSearchProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),

      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onChanged: provider.updateQuery,
              decoration: InputDecoration(
                hintText: 'Search in Soumyajit Das',
                border: InputBorder.none,
                suffixIcon: provider.query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => provider.updateQuery(""),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
