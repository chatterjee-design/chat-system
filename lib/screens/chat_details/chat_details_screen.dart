import 'package:flutter/material.dart';

import '../../utils/time_formater.dart';
import 'components/chat_content.dart';

class ChatDetailScreen extends StatelessWidget {
  final String currentUserId = '1';

  final List<Map<String, dynamic>> messages = [
    {
      'id': '1',
      'senderId': '1',
      'name': 'You',
      'avatar': '',
      'isOnline': true,
      'timestamp': '2025-08-04T09:45:00Z',
      'type': 'text',
      'content': 'Hey, how are you?',
    },
    {
      'id': '1',
      'senderId': '1',
      'name': 'You',
      'avatar': '',
      'isOnline': true,
      'timestamp': '2025-08-04T09:45:00Z',
      'type': 'text',
      'content': 'Hey, how are you?',
    },
    {
      'id': '1',
      'senderId': '1',
      'name': 'You',
      'avatar': '',
      'isOnline': true,
      'timestamp': '2025-08-04T09:45:00Z',
      'type': 'text',
      'content': 'Hey, how are you?',
    },
    {
      'id': '2',
      'senderId': '1',
      'name': 'You',
      'avatar': '',
      'isOnline': true,
      'timestamp': '2025-08-04T09:60:80Z',
      'type': 'text',
      'content': 'Hey again!',
    },
    {
      'id': '3',
      'senderId': '2',
      'name': 'John Doe',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'isOnline': true,
      'timestamp': '2025-08-04T09:46:00Z',
      'type': 'text',
      'content': 'Hi!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final sender = messages.firstWhere(
      (msg) => msg['senderId'] != currentUserId,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(sender['avatar'])),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: sender['isOnline'] ? Colors.green : Colors.white,
                      border: Border.all(color: Colors.green, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                sender['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.more_vert, color: Colors.black),
          SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          final isSender = msg['senderId'] == currentUserId;

          final DateTime currentTime = DateTime.parse(
            msg['timestamp'],
          ).toLocal();

          // Compare with previous message
          DateTime? previousTime;
          if (index > 0) {
            previousTime = DateTime.parse(
              messages[index - 1]['timestamp'],
            ).toLocal();
          }

          // Show time only if first message or time gap > 2 mins
          final bool showTimestamp =
              index == 0 ||
              previousTime == null ||
              currentTime.difference(previousTime).inMinutes > 2 ||
              msg['senderId'] != messages[index - 1]['senderId'];

          // Show avatar/name if sender changed
          final bool showAvatarAndName =
              index == 0 || msg['senderId'] != messages[index - 1]['senderId'];

          return Align(
            alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: isSender
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (!isSender && showAvatarAndName)
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(msg['avatar']),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          msg['name'],
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSender
                          ? Colors.lightBlue[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: chatContent(msg),
                  ),
                  const SizedBox(height: 4),
                  if (showTimestamp)
                    Text(
                      AppFormatedTime.getTime(
                        msg['timestamp'],
                      ), // shows '4:05 PM'
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
