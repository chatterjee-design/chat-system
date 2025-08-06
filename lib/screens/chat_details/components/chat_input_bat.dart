import 'package:flutter/material.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void sendMessage() {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      print('Send: $message');
      _controller.clear();
      // Optionally add: FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // pushes up with keyboard
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            // Plus Button
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () {},
            ),

            // Input Field
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: const TextStyle(color: Colors.black54),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),

            const SizedBox(width: 8),

            // Conditional Icons
            hasText
                ? IconButton(
                    icon: const Icon(Icons.send, color: Colors.black),
                    onPressed: sendMessage,
                  )
                : Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.image_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.mic_none_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
