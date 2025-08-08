import 'dart:developer';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class ChatInputBar extends StatefulWidget {
  final Function scrollToBottom;
  const ChatInputBar({super.key, required this.scrollToBottom});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool hasText = false;
  bool showEmojiPicker = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        hasText = _controller.text.trim().isNotEmpty;
      });
    });

    focusNode.addListener(() {
      if (focusNode.hasFocus && showEmojiPicker) {
        // Hide emoji picker if keyboard is opened
        setState(() {
          showEmojiPicker = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void sendMessage() {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      _controller.clear();
      widget.scrollToBottom();
    }
  }

  void _toggleEmojiPicker(BuildContext context) {
    if (showEmojiPicker) {
      Navigator.of(context).pop();
      setState(() {
        showEmojiPicker = false;
      });
      focusNode.requestFocus();
    } else {
      focusNode.unfocus();
      setState(() {
        showEmojiPicker = true;
      });
      _showEmojiPickerBottomSheet(context).whenComplete(() {
        setState(() {
          showEmojiPicker = false;
        });
        focusNode.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.black),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(color: Colors.black54),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () => _toggleEmojiPicker(context),
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
        ),
        // if (showEmojiPicker)
        //   SizedBox(
        //     height: 250,
        //     child: EmojiPicker(
        //       onEmojiSelected: (category, emoji) {
        //         _controller.text += emoji.emoji;
        //       },
        //       onBackspacePressed: () {},
        //       textEditingController: _controller,
        //     ),
        //   ),
        // Show emoji picker if toggled
      ],
    );
  }

  Future<void> _showEmojiPickerBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final height = MediaQuery.of(context).size.height * 0.95;
        return SizedBox(
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),

            child: Padding(
              padding: EdgeInsets.only(bottom: 20, right: 10, left: 10),

              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  Navigator.pop(context);
                },

                config: Config(
                  viewOrderConfig: ViewOrderConfig(
                    bottom: EmojiPickerItem.categoryBar,
                    top: EmojiPickerItem.searchBar,
                    middle: EmojiPickerItem.emojiView,
                  ),
                  emojiViewConfig: EmojiViewConfig(
                    columns: 9,
                    emojiSizeMax: 27,
                    verticalSpacing: 5,
                    horizontalSpacing: 5,
                    backgroundColor: Colors.white,
                  ),

                  searchViewConfig: SearchViewConfig(
                    backgroundColor: Colors.white,
                  ),
                  categoryViewConfig: CategoryViewConfig(
                    indicatorColor: Colors.teal,
                    iconColorSelected: Colors.teal,
                    dividerColor: Colors.transparent,
                    backgroundColor: Colors.white,
                  ),
                  bottomActionBarConfig: BottomActionBarConfig(
                    showBackspaceButton: true,
                    showSearchViewButton: true,
                    customBottomActionBar: (config, state, showSearchView) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          // horizontal: 10,
                          vertical: 10,
                        ),
                        color: Colors.white, // background color
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OutlinedButton.icon(
                                  onPressed: showSearchView,
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.blueGrey,
                                  ),
                                  label: Text(
                                    'Search',
                                    style: TextStyle(color: Colors.blueGrey),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.blueGrey),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },

                    backgroundColor: Colors.white,
                  ),
                ),
                onBackspacePressed: () {},
                textEditingController: _controller,
              ),
            ),
          ),
        );
      },
    );
  }
}
