import 'package:flutter/material.dart';

import 'components/chat_list_card.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  final List<Map<String, String>> chatList = const [
    {
      'name': 'Alice',
      'message': 'Hey there! How are you?',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'timestamp': '2025-08-05T00:30:00Z',
    },
    {
      'name': 'Bob',
      'message': 'Got the documents. Thanks!',
      'avatar': 'https://i.pravatar.cc/150?img=7',
      'timestamp': '2025-08-04T09:45:00Z',
    },
    {
      'name': 'Charlie',
      'message': 'Let\'s meet at 5 PM',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'timestamp': '2025-08-03T17:00:00Z',
    },
    {
      'name': 'Daisy',
      'message': 'Looking forward to our call.',
      'avatar': 'https://i.pravatar.cc/150?img=4',
      'timestamp': '2025-08-02T19:50:00Z',
    },
    {
      'name': 'Eve',
      'message': 'Can you review the PR?',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'timestamp': '2025-07-01T18:15:00Z',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats'), centerTitle: true),
      body: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          final chat = chatList[index];
          return chatListCard(chat, context);
        },
      ),
    );
  }
}
