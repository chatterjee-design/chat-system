import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../provider/chat_details_provider.dart';
import '../../../../../utils/emojie_storage.dart';
import '../../widgets/bubbble_widget.dart';
import '../../widgets/show_emojie_picker.dart';

class ChatContainer extends StatefulWidget {
  final Map<String, dynamic> msg;
  final bool isSender;
  final bool showTime;
  final int index;
  final bool showAvatarAndName;
  final List<Map<String, dynamic>> messages;

  const ChatContainer({
    super.key,
    required this.msg,
    required this.isSender,
    required this.showTime,
    required this.index,
    required this.showAvatarAndName,
    required this.messages,
  });

  @override
  State<ChatContainer> createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  bool isStarMessage = false;

  void copyMessage(BuildContext context, String message) {
    Clipboard.setData(ClipboardData(text: message));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));

    Navigator.pop(context);
  }

  void toggleStarMessage() {
    setState(() {
      isStarMessage = !isStarMessage;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatDetailsProvider>(context);

    final backgroundColor = widget.isSender
        ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.7)
        : Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () {
        showEmojiPicker();
      },

      onHorizontalDragUpdate: (details) {
        chatProvider.handleHorizontalDragUpdate(
          details,
          widget.isSender,
          widget.index,
        );
      },

      onHorizontalDragEnd: (_) {
        chatProvider.handleSwipeEnd(
          index: widget.index,
          isSender: widget.isSender,
          msg: widget.msg,
        );
      },

      child: Transform.translate(
        offset: Offset(chatProvider.getDx(widget.index), 0),
        child: BubbleWidget(
          showAvatarAndName: widget.showAvatarAndName,
          isSender: widget.isSender,
          showTime: widget.showTime,
          msg: widget.msg,
          context: context,
          index: widget.index,
          messages: widget.messages,
          backgroundColor: backgroundColor,
          isStarMessage: isStarMessage,
        ),
      ),
    );
  }

  Future<void> showEmojiPicker() async {
    List<String> emojis = await EmojiStorage.getRecentEmojis();

    final emoji = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(),
      constraints: BoxConstraints(
        minHeight: 0,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...emojis.map(
                      (e) => Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context, e),
                          icon: Text(e, style: const TextStyle(fontSize: 20)),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          final selectedEmoji =
                              await showEmojiPickerBottomSheet(context);
                          if (selectedEmoji != null) {
                            await EmojiStorage.addEmoji(selectedEmoji);

                            setState(() {
                              widget.msg["reaction"] = selectedEmoji;
                            });
                            Navigator.pop(context, selectedEmoji);
                          }
                        },
                        icon: const Icon(Icons.add_reaction_outlined, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ListTile(
                  leading: const Icon(Icons.reply),
                  title: const Text("Quote in reply"),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.markunread),
                  title: const Text("Mark as unread"),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(isStarMessage ? Icons.star : Icons.star_border),
                  title: Text(isStarMessage ? "Unstar" : "Star"),
                  onTap: () {
                    toggleStarMessage();
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.add_task),
                  title: const Text("Add to Tasks"),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.copy),
                  title: const Text("Copy text"),
                  onTap: () =>
                      copyMessage(context, widget.msg["content"] ?? ""),
                ),
                ListTile(
                  leading: const Icon(Icons.link),
                  title: const Text("Copy message link"),
                  onTap: () {
                    copyMessage(context, widget.msg["content"] ?? "");
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.feedback_outlined),
                  title: const Text("Send feedback on this message"),
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      },
    );

    if (emoji != null) {
      await EmojiStorage.addEmoji(emoji);
      setState(() => widget.msg["reaction"] = emoji);
    }
  }
}
