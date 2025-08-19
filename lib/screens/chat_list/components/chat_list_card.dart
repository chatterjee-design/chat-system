import 'package:flutter/material.dart';
import '../../../utils/time_formater.dart';
import '../../../chat_details/presentation/screens/chat_details_screen.dart';

Widget chatListCard(Map<String, String> chat, BuildContext context) {
  final timestamp = chat['timestamp'];
  String formattedTime = '';

  if (timestamp != null) {
    formattedTime = AppFormatedTime.smartTimestamp(timestamp);
  }

  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

    leading: CircleAvatar(
      radius: 23,
      backgroundImage: NetworkImage(chat['avatar']!),
    ),

    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            chat['name']!,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        Text(
          formattedTime,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    ),

    subtitle: Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        chat['message']!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
          fontStyle: FontStyle.italic,
        ),
      ),
    ),

    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatDetailScreen()),
      );
    },
  );
}
