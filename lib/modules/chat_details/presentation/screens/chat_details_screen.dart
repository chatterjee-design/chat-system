import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/messages.dart';
import '../../../search_chat/presentation/screens/chat_search_screen.dart';
import '../../../shared/presentation/screens/shared_screen.dart';
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
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SharedScreen()),
                );
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
}
