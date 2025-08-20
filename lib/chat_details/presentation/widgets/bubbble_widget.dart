import 'package:flutter/material.dart';

import '../../../core/font/app_font.dart';
import '../../../utils/time_formater.dart';
import 'chat_content.dart';

class BubbleWidget extends StatelessWidget {
  final bool showAvatarAndName;
  final bool isSender;
  final bool showTime;
  final Map<String, dynamic> msg;
  final BuildContext context;
  final int index;
  final List<Map<String, dynamic>> messages;
  final Color backgroundColor;
  final bool isStarMessage;

  const BubbleWidget({
    super.key,
    required this.showAvatarAndName,
    required this.isSender,
    required this.showTime,
    required this.msg,
    required this.context,
    required this.index,
    required this.messages,
    required this.backgroundColor,
    required this.isStarMessage,
  });

  bool shouldShowBottomLeftRadiusForCurrent({
    required int index,
    required List<Map<String, dynamic>> messages,
  }) {
    if (index == 0) return true; // Last message in chat

    final currentMsg = messages[index];
    final previousMsg = messages[index - 1]; // previous visually (lower index)

    final sameSender = currentMsg['senderId'] == previousMsg['senderId'];

    final timeDiff = DateTime.parse(
      currentMsg['timestamp'],
    ).difference(DateTime.parse(previousMsg['timestamp'])).inMinutes;

    final isTimeBreak = timeDiff.abs() > 2;

    return !(sameSender && !isTimeBreak);
  }

  bool shouldShowBottomRightRadiusForCurrent({
    required int index,
    required List<Map<String, dynamic>> messages,
  }) {
    if (index == 0) return true;

    final currentMsg = messages[index];
    final previousMsg = messages[index - 1];

    final sameSender = currentMsg['senderId'] == previousMsg['senderId'];

    final timeDiff = DateTime.parse(
      currentMsg['timestamp'],
    ).difference(DateTime.parse(previousMsg['timestamp'])).inMinutes;

    final isTimeBreak = timeDiff.abs() > 2;

    return !(sameSender && !isTimeBreak);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: showAvatarAndName ? 20 : 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: !isSender
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        spacing: !isSender ? 10 : 0,
        children: [
          !isSender
              ? showAvatarAndName || showTime || isStarMessage
                    ? Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: CircleAvatar(
                          radius: 17,
                          backgroundImage: NetworkImage(msg['avatar']!),
                        ),
                      )
                    : const SizedBox(width: 34, height: 34)
              : const SizedBox.shrink(),
          Column(
            crossAxisAlignment: !isSender
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              showAvatarAndName || showTime || isStarMessage
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 6,
                      ),
                      child: Row(
                        spacing: !isSender
                            ? 10
                            : isStarMessage
                            ? 10
                            : 0,
                        mainAxisAlignment: !isSender
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          !isSender
                              ? Text(
                                  msg['name'],
                                  style: appText(
                                    size: 13,
                                    weight: FontWeight.w400,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          Text(
                            AppFormatedTime.formattedTimestamp(
                              msg['timestamp'],
                            ),
                            style: appText(size: 11, weight: FontWeight.w400),
                          ),
                          // SizedBox(width: 2),
                          isStarMessage
                              ? Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.blueGrey[700],
                                )
                              : SizedBox(),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      !isSender
                          ? (!showTime && !showAvatarAndName ? 5 : 20)
                          : 20,
                    ),
                    topRight: Radius.circular(
                      isSender ? (!showTime ? 5 : 20) : 20,
                    ),
                    bottomLeft: Radius.circular(
                      !isSender
                          ? (shouldShowBottomLeftRadiusForCurrent(
                                  index: index,
                                  messages: messages,
                                )
                                ? 20
                                : 5)
                          : 20,
                    ),
                    bottomRight: Radius.circular(
                      isSender
                          ? (shouldShowBottomRightRadiusForCurrent(
                                  index: index,
                                  messages: messages,
                                )
                                ? 20
                                : 5)
                          : 20,
                    ),
                  ),
                  border: msg['type'] != 'text'
                      ? Border.all(color: backgroundColor, width: 3)
                      : null,
                  color: msg['type'] != 'pdf' ? backgroundColor : Colors.white,
                ),
                child: chatContent(
                  msg,
                  isSender: isSender,
                  showAvatarAndName: showAvatarAndName,
                  showTime: showTime,
                  shouldShowBottomLeftRadiusForCurrent:
                      shouldShowBottomLeftRadiusForCurrent(
                        index: index,
                        messages: messages,
                      ),
                  shouldShowBottomRightRadiusForCurrent:
                      shouldShowBottomRightRadiusForCurrent(
                        index: index,
                        messages: messages,
                      ),
                  color: isSender ? Colors.white : Colors.black,
                  context: context,
                ),
              ),
              if (msg["reaction"] != null)
                Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: Colors.blueGrey, width: 1),
                  ),
                  child: Text(
                    msg["reaction"],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
