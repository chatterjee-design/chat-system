import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'components/chat_container.dart';
import 'components/chat_input_bat.dart';

class ChatDetailScreen extends StatelessWidget {
  final String currentUserId = '1';

  final List<Map<String, dynamic>> messages = [
    // --- Today ---
    {
      'id': '1',
      'senderId': '1',
      'name': 'You',
      'avatar': '',
      'isOnline': true,
      "timestamp": "2025-08-06T00:00:00Z",
      'type': 'text',
      'content': 'Hey, how are you?',
    },
    {
      'id': '1',
      'senderId': '1',
      'name': 'You',
      'avatar': '',
      'isOnline': true,
      "timestamp": "2025-08-06T00:02:00Z",
      'type': 'text',
      'content': 'Hey, how are you?',
    },
    {
      'id': '1',
      'senderId': '1',
      'name': 'You',
      'avatar': '',
      'isOnline': true,
      'timestamp': '2025-08-06T09:30:00Z',
      'type': 'text',
      'content': 'Hey, how are you?',
    },
    {
      'id': '1',
      'senderId': '1',
      'name': 'You',
      'avatar': '',
      'isOnline': true,
      'timestamp': '2025-08-06T09:30:00Z',
      'type': 'text',
      'content': 'Hey, how are you?',
    },
    {
      'id': '1',
      'senderId': '1',
      'name': 'You',
      'avatar': '',
      'isOnline': true,
      'timestamp': '2025-08-06T09:30:00Z',
      'type': 'text',
      'content': 'Hey, how are you?',
    },
    {
      'id': '2',
      'senderId': '2',
      'name': 'John Doe',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'isOnline': true,
      'timestamp': '2025-08-06T08:31:00Z',
      'type': 'text',
      'content': 'Hey! All good here.',
    },
    {
      'id': '2',
      'senderId': '2',
      'name': 'John Doe',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'isOnline': true,
      'timestamp': '2025-08-06T08:31:00Z',
      'type': 'text',
      'content': 'Hey! All good here.',
    },
    {
      'id': '3',
      'senderId': '2',
      'name': 'John Doe',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'isOnline': true,
      'timestamp': '2025-08-06T09:31:30Z',
      'type': 'text',
      'content': 'Just finished a meeting.',
    },
    {
      'id': '4',
      'senderId': '2',
      'name': 'John Doe',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'isOnline': true,
      'timestamp': '2025-08-06T09:32:00Z',
      'type': 'text',
      'content': 'What about you?',
    },
    {
      'id': '5',
      'senderId': '1',
      'name': 'You',
      'avatar': '',
      'isOnline': true,
      'timestamp': '2025-08-06T09:33:00Z',
      'type': 'image',
      'content':
          'https://images.pexels.com/photos/33209986/pexels-photo-33209986.jpeg',
    },
    {
      'id': '6',
      'senderId': '2',
      'name': 'John Doe',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'isOnline': true,
      'timestamp': '2025-08-06T09:34:00Z',
      'type': 'pdf',
      'content':
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    },

    // --- Yesterday ---
    {
      'id': '7',
      'senderId': '1',
      'name': 'You',
      'avatar': '',
      'isOnline': true,
      'timestamp': '2025-08-05T18:15:00Z',
      'type': 'text',
      'content': 'Did you get the report?',
    },
    {
      'id': '8',
      'senderId': '2',
      'name': 'John Doe',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'isOnline': false,
      'timestamp': '2025-08-05T18:20:00Z',
      'type': 'text',
      'content':
          'Yes, I sent it back with comments. Please review the points I marked in red.',
    },
    {
      'id': '9',
      'senderId': '2',
      'name': 'John Doe',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'isOnline': false,
      'timestamp': '2025-08-05T18:21:00Z',
      'type': 'text',
      'content': 'Let me know if anything needs clarification.',
    },
    {
      'id': '10',
      'senderId': '2',
      'name': 'John Doe',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'isOnline': false,
      'timestamp': '2025-08-05T18:22:00Z',
      'type': 'text',
      'content': 'We can finalize it tomorrow.',
    },

    // --- 7 Days Ago ---
    {
      'id': '11',
      'senderId': '3',
      'name': 'Jane Smith',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'isOnline': false,
      'timestamp': '2025-07-30T11:00:00Z',
      'type': 'text',
      'content': 'Meeting postponed to next Monday.',
    },
    {
      'id': '12',
      'senderId': '1',
      'name': 'You',
      'avatar': '',
      'isOnline': true,
      'timestamp': '2025-07-30T11:03:00Z',
      'type': 'image',
      'content':
          'https://images.pexels.com/photos/1472999/pexels-photo-1472999.jpeg',
    },
    {
      'id': '13',
      'senderId': '3',
      'name': 'Jane Smith',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'isOnline': false,
      'timestamp': '2025-07-30T11:05:00Z',
      'type': 'pdf',
      'content': 'https://www.africau.edu/images/default/sample.pdf',
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
          final bool showTimestamp =
              index == 0 ||
              msg['senderId'] != messages[index - 1]['senderId'] ||
              DateTime.parse(msg['timestamp'])
                      .difference(
                        DateTime.parse(messages[index - 1]['timestamp']),
                      )
                      .abs()
                      .inMinutes >
                  2;

          final bool showAvatarAndName =
              index == 0 || msg['senderId'] != messages[index - 1]['senderId'];

          return chatContainer(
            index: index,
            msg: msg,
            isSender: isSender,
            context: context,
            showAvatarAndName: showAvatarAndName,
            showTime: showTimestamp,
            messages: messages,
          );
        },
      ),
      bottomNavigationBar: ChatInputBar(),
    );
  }
}
