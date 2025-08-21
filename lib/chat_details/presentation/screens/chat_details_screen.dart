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
    // --- Starting Conversation ---
    {
      "senderId": "1",
      "name": "Alice Brown",
      "avatar":
          "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
      "isOnline": true,
      "timestamp": "2025-08-21T07:55:00Z",
      "type": "text",
      "content":
          "Good morning! I just finished drafting the **API integration guide** 📄. Need your review before we finalize.",
      "replied": null,
    },
    {
      "senderId": "2",
      "name": "Bob Smith",
      "avatar":
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
      "isOnline": true,
      "timestamp": "2025-08-21T07:58:00Z",
      "type": "text",
      "content":
          "Morning Alice! Great, please share the draft. I’ll also attach the **official requirements doc** so we align.",
      "replied": {
        "name": "Alice Brown",
        "avatar":
            "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
        "type": "text",
        "content":
            "Good morning! I just finished drafting the **API integration guide** 📄. Need your review before we finalize.",
      },
    },

    // --- Documentation Exchange ---
    {
      "senderId": "1",
      "name": "Alice Brown",
      "avatar":
          "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
      "isOnline": true,
      "timestamp": "2025-08-21T08:10:00Z",
      "type": "pdf",
      "content": "assets/pdf/api_guide.pdf",
      "replied": null,
    },
    {
      "senderId": "2",
      "name": "Bob Smith",
      "avatar":
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
      "isOnline": true,
      "timestamp": "2025-08-21T08:12:00Z",
      "type": "pdf",
      "content":
          "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
      "replied": {
        "name": "Alice Brown",
        "avatar":
            "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
        "type": "pdf",
        "content": "assets/pdf/api_guide.pdf",
      },
    },

    // --- Continuous Notes ---
    {
      "senderId": "1",
      "name": "Alice Brown",
      "avatar":
          "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
      "isOnline": true,
      "timestamp": "2025-08-21T08:20:00Z",
      "type": "text",
      "content":
          "I also added a **sequence diagram** for the request flow. It should help new developers.",
      "replied": null,
    },
    {
      "senderId": "1",
      "name": "Alice Brown",
      "avatar":
          "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
      "isOnline": true,
      "timestamp": "2025-08-21T08:22:00Z",
      "type": "image",
      "content":
          "https://images.pexels.com/photos/1181675/pexels-photo-1181675.jpeg",
      "replied": null,
    },
    {
      "senderId": "2",
      "name": "Bob Smith",
      "avatar":
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
      "isOnline": true,
      "timestamp": "2025-08-21T08:25:00Z",
      "type": "text",
      "content":
          "Nice diagram! Can we also add an example request/response payload in the guide?",
      "replied": {
        "name": "Alice Brown",
        "avatar":
            "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
        "type": "text",
        "content":
            "I also added a **sequence diagram** for the request flow. It should help new developers.",
      },
    },
    {
      "senderId": "2",
      "name": "Bob Smith",
      "avatar":
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
      "isOnline": true,
      "timestamp": "2025-08-21T08:28:00Z",
      "type": "text",
      "content":
          "Also, remember to include the authentication section clearly. That’s a frequent support ticket issue.",
      "replied": null,
    },

    // --- Evening Messages ---
    {
      "senderId": "2",
      "name": "Bob Smith",
      "avatar":
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
      "isOnline": true,
      "timestamp": "2025-08-21T18:30:00Z",
      "type": "text",
      "content":
          "Just reviewed the doc 📖. It’s solid, but let’s polish the **error handling** part before release.",
      "replied": null,
    },
    {
      "senderId": "1",
      "name": "Alice Brown",
      "avatar":
          "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
      "isOnline": true,
      "timestamp": "2025-08-21T18:35:00Z",
      "type": "text",
      "content":
          "Got it 👍. I’ll refine the error section and push the final draft to Confluence.\n\nHere’s a quick reference: https://www.docsapi.com/errors",
      "replied": {
        "name": "Bob Smith",
        "avatar":
            "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
        "type": "text",
        "content":
            "Just reviewed the doc 📖. It’s solid, but let’s polish the **error handling** part before release.",
      },
    },

    // --- Night Messages ---
    {
      "senderId": "2",
      "name": "Bob Smith",
      "avatar":
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
      "isOnline": true,
      "timestamp": "2025-08-21T22:10:00Z",
      "type": "text",
      "content":
          "Good work today Alice 👏. Let’s finalize tomorrow morning. I’ll prepare the checklist tonight.",
      "replied": null,
    },
    {
      "senderId": "1",
      "name": "Alice Brown",
      "avatar":
          "https://images.pexels.com/photos/3760854/pexels-photo-3760854.jpeg",
      "isOnline": true,
      "timestamp": "2025-08-21T22:15:00Z",
      "type": "text",
      "content":
          "Thanks Bob 🌙. I’ll be ready with the final version tomorrow. Have a good night!",
      "replied": {
        "name": "Bob Smith",
        "avatar":
            "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
        "type": "text",
        "content":
            "Good work today Alice 👏. Let’s finalize tomorrow morning. I’ll prepare the checklist tonight.",
      },
    },
  ];
}
