import 'dart:async';
import 'package:flutter/material.dart';
import '../../../screens/chat_search_screen.dart/chat_search_screen.dart';
import 'components/chat_container.dart';
import 'components/chat_input_bat.dart';
import 'components/jump_to_bottom_btn.dart';
import '../widgets/weavy_line.dart';

class ChatDetailScreen extends StatefulWidget {
  ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final String currentUserId = '1';

  final ScrollController _scrollController = ScrollController();

  bool showJumpToBottom = false;

  Timer? _hideButtonTimer;
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_handleScroll);
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController
              .position
              .minScrollExtent, // min scroll extent bcz listview is reversed
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleScroll() {
    final distanceFromBottom = _scrollController.position.pixels;
    // log(distanceFromBottom.toString());

    if (distanceFromBottom > 300) {
      if (!showJumpToBottom) {
        setState(() => showJumpToBottom = true);
      }

      _hideButtonTimer?.cancel();
      _hideButtonTimer = Timer(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => showJumpToBottom = false);
      });
    } else {
      if (showJumpToBottom) {
        setState(() => showJumpToBottom = false);
        _hideButtonTimer?.cancel();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _hideButtonTimer?.cancel();
    super.dispose();
  }

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
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'Search') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatSearchScreen()),
                );
              } else if (value == 'Shared') {
                // Handle shared action
              } else if (value == 'Board') {
                // Handle board action
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Search',
                child: SizedBox(
                  width: 150, // Increase width
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.black54),
                      SizedBox(width: 10),
                      Text('Search'),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'Shared',
                child: SizedBox(
                  width: 150, // Increase width
                  child: Row(
                    children: const [
                      Icon(Icons.folder_open, color: Colors.black54),
                      SizedBox(width: 10),
                      Text('Shared'),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'Board',
                child: SizedBox(
                  width: 150, // Increase width
                  child: Row(
                    children: const [
                      Icon(Icons.push_pin, color: Colors.black54),
                      SizedBox(width: 10),
                      Text('Board'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        reverse: true,
        controller: _scrollController,
        padding: const EdgeInsets.all(12),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          // log(' $index, ${msg['content']}');
          final isSender = msg['senderId'] == currentUserId;

          final bool isLastMessage = index == messages.length - 1;

          final bool showTimestamp =
              isLastMessage ||
              msg['senderId'] != messages[index + 1]['senderId'] ||
              DateTime.parse(msg['timestamp'])
                      .difference(
                        DateTime.parse(messages[index + 1]['timestamp']),
                      )
                      .abs()
                      .inMinutes >
                  2;

          final bool showAvatarAndName =
              isLastMessage ||
              msg['senderId'] != messages[index + 1]['senderId'];

          if (index == 2) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    // spacing: 8,
                    children: [
                      Expanded(child: WavyLine()),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Unread',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),

                      Expanded(child: WavyLine()),
                    ],
                  ),
                ),

                ChatContainer(
                  index: index,
                  msg: msg,
                  isSender: isSender,
                  // context: context,
                  showAvatarAndName: showAvatarAndName,
                  showTime: showTimestamp,
                  messages: messages,
                ),
              ],
            );
          }

          return ChatContainer(
            index: index,
            msg: msg,
            isSender: isSender,
            // context: context,
            showAvatarAndName: showAvatarAndName,
            showTime: showTimestamp,
            messages: messages,
          );
        },
      ),
      bottomNavigationBar: ChatInputBar(
        scrollToBottom: () {
          scrollToBottom();
        },
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: showJumpToBottom ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: IgnorePointer(
          ignoring: !showJumpToBottom,
          child: jumpToBottomBtn(scrollToBottom: scrollToBottom),
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> messages = [
    {
      'id': '1',
      'senderId': '1',
      'name': 'Cat Lover',
      'avatar':
          'https://images.pexels.com/photos/1643456/pexels-photo-1643456.jpeg',
      'isOnline': true,
      'timestamp': '2025-08-06T08:00:00Z',
      'type': 'text',
      'content': 'This cat is adorable!',
    },
    {
      'id': '2',
      'senderId': '1',
      'name': 'Cat Lover',
      'avatar':
          'https://images.pexels.com/photos/1643456/pexels-photo-1643456.jpeg',
      'isOnline': true,
      'timestamp': '2025-08-06T08:03:00Z',
      'type': 'image',
      'content':
          'https://images.pexels.com/photos/2071873/pexels-photo-2071873.jpeg',
    },
    {
      'id': '3',
      'senderId': '1',
      'name': 'Cat Lover',
      'avatar':
          'https://images.pexels.com/photos/1643456/pexels-photo-1643456.jpeg',
      'isOnline': true,
      'timestamp': '2025-08-06T08:04:30Z',
      'type': 'text',
      'content': 'Dogs are cute too!',
    },
    {
      'id': '7',
      'senderId': '1',
      'name': 'Foodie',
      'avatar':
          'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg',
      'isOnline': true,
      'timestamp': '2025-08-06T08:07:00Z',
      'type': 'pdf',
      'content': 'assets/pdf/pdf.pdf',
    },
    {
      'id': '7',
      'senderId': '1',
      'name': 'Foodie',
      'avatar':
          'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg',
      'isOnline': true,
      'timestamp': '2025-08-06T08:07:00Z',
      'type': 'text',
      'content':
          ' https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    },
    {
      'id': '4',
      'senderId': '2',
      'name': 'Foodie',
      'avatar':
          'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg',
      'isOnline': true,
      'timestamp': '2025-08-06T08:05:00Z',
      'type': 'text',
      'content': 'I made pasta today. Want some? food.ai',
    },
    {
      'id': '4',
      'senderId': '2',
      'name': 'Foodie',
      'avatar':
          'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg',
      'isOnline': true,
      'timestamp': '2025-08-06T08:05:00Z',
      'type': 'text',
      'content': 'kabab.com',
    },
    {
      'id': '5',
      'senderId': '2',
      'name': 'Foodie',
      'avatar':
          'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg',
      'isOnline': true,
      'timestamp': '2025-08-06T08:05:50Z',
      'type': 'image',
      'content':
          'https://images.pexels.com/photos/262959/pexels-photo-262959.jpeg',
    },
    {
      'id': '6',
      'senderId': '2',
      'name': 'Foodie',
      'avatar':
          'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg',
      'isOnline': true,
      'timestamp': '2025-08-06T08:06:30Z',
      'type': 'text',
      'content': 'Check out this recipe!',
    },
    {
      'id': '7',
      'senderId': '2',
      'name': 'Foodie',
      'avatar':
          'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg',
      'isOnline': true,
      'timestamp': '2025-08-06T08:07:00Z',
      'type': 'pdf',
      'content': 'assets/pdf/pdf.pdf',
    },
    {
      'id': '8',
      'senderId': '1',
      'name': 'Cat Lover',
      'avatar':
          'https://images.pexels.com/photos/15925994/pexels-photo-15925994.jpeg',
      'isOnline': false,
      'timestamp': '2025-08-06T08:09:30Z',
      'type': 'text',
      'content': 'Look at this sleepy kitty!',
    },
    {
      'id': '9',
      'senderId': '1',
      'name': 'Cat Lover',
      'avatar':
          'https://images.pexels.com/photos/15925994/pexels-photo-15925994.jpeg',
      'isOnline': false,
      'timestamp': '2025-08-06T08:10:50Z',
      'type': 'image',
      'content':
          'https://images.pexels.com/photos/15925994/pexels-photo-15925994.jpeg',
    },
    {
      'id': '10',
      'senderId': '1',
      'name': 'Cat Lover',
      'avatar':
          'https://images.pexels.com/photos/15925994/pexels-photo-15925994.jpeg',
      'isOnline': false,
      'timestamp': '2025-08-06T08:11:30Z',
      'type': 'pdf',
      'content': 'assets/pdf/pdf.pdf',
    },
    {
      'id': '11',
      'senderId': '2',
      'name': 'Foodie',
      'avatar':
          'https://images.pexels.com/photos/2641886/pexels-photo-2641886.jpeg',
      'isOnline': false,
      'timestamp': '2025-08-06T08:14:00Z',
      'type': 'text',
      'content': 'assets/pdf/pdf.pdf',
    },
    {
      'id': '12',
      'senderId': '2',
      'name': 'Foodie',
      'avatar':
          'https://images.pexels.com/photos/2641886/pexels-photo-2641886.jpeg',
      'isOnline': false,
      'timestamp': '2025-08-06T08:15:00Z',
      'type': 'text',
      'content': 'Have you tried quinoa salad before?',
    },
    {
      'id': '13',
      'senderId': '2',
      'name': 'Foodie',
      'avatar':
          'https://images.pexels.com/photos/2641886/pexels-photo-2641886.jpeg',
      'isOnline': false,
      'timestamp': '2025-08-06T08:16:00Z',
      'type': 'text',
      'content': 'It’s really filling and super quick to make.',
    },
    {
      'id': '14',
      'senderId': '2',
      'name': 'Foodie',
      'avatar':
          'https://images.pexels.com/photos/2641886/pexels-photo-2641886.jpeg',
      'isOnline': false,
      'timestamp': '2025-08-06T08:16:50Z',
      'type': 'image',
      'content':
          'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg',
    },
    {
      'id': '15',
      'senderId': '1',
      'name': 'Cat Lover',
      'avatar':
          'https://images.pexels.com/photos/2071873/pexels-photo-2071873.jpeg',
      'isOnline': false,
      'timestamp': '2025-08-06T08:20:00Z',
      'type': 'image',
      'content':
          'https://images.pexels.com/photos/2071873/pexels-photo-2071873.jpeg',
    },
    {
      'id': '16',
      'senderId': '1',
      'name': 'Cat Lover',
      'avatar':
          'https://images.pexels.com/photos/2071873/pexels-photo-2071873.jpeg',
      'isOnline': false,
      'timestamp': '2025-08-06T08:22:00Z',
      'type': 'text',
      'content': 'Let’s adopt one someday!',
    },
    {
      'id': '17',
      'senderId': '2',
      'name': 'Foodie',
      'avatar':
          'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg',
      'isOnline': true,
      'timestamp': '2025-08-06T08:25:00Z',
      'type': 'text',
      'content': 'That sounds good! Let’s meet this weekend.',
    },
    {
      'id': '18',
      'senderId': '2',
      'name': 'Foodie',
      'avatar':
          'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg',
      'isOnline': true,
      'timestamp': '2025-08-06T08:25:50Z',
      'type': 'text',
      'content': 'Also, I’ll bring the cookies 🍪',
    },
    {
      'id': '19',
      'senderId': '2',
      'name': 'Foodie',
      'avatar':
          'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg',
      'isOnline': true,
      'timestamp': '2025-08-06T08:26:30Z',
      'type': 'text',
      'content': 'Freshly baked this morning!',
    },
    {
      'id': '20',
      'senderId': '2',
      'name': 'Foodie',
      'avatar':
          'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg',
      'isOnline': true,
      'timestamp': '2025-08-06T08:27:00Z',
      'type': 'pdf',
      'content': 'assets/pdf/pdf.pdf',
    },
  ];
}
