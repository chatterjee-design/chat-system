import 'package:flutter/material.dart';

import '../../../core/font/app_font.dart';
import '../../../utils/time_formater.dart';
import 'chat_content.dart';

bool shouldShowBottomLeftRadiusForCurrent({
  required int index,
  required List<Map<String, dynamic>> messages,
}) {
  if (index == messages.length - 1) return true;

  final currentMsg = messages[index];
  final nextMsg = messages[index + 1];

  final sameSender = currentMsg['senderId'] == nextMsg['senderId'];

  final nextShowTime =
      index + 1 == 0 ||
      DateTime.parse(
            nextMsg['timestamp'],
          ).difference(DateTime.parse(currentMsg['timestamp'])).inMinutes >
          2 ||
      currentMsg['senderId'] != nextMsg['senderId'];

  final nextShowAvatar = currentMsg['senderId'] != nextMsg['senderId'];

  if (sameSender && !nextShowTime && !nextShowAvatar) {
    return false; // Continue group — no bottomLeft radius
  }

  return true; // Last in group — apply bottomLeft radius
}

bool shouldShowBottomRightRadiusForCurrent({
  required int index,
  required List<Map<String, dynamic>> messages,
}) {
  if (index == messages.length - 1) return true;

  final currentMsg = messages[index];
  final nextMsg = messages[index + 1];

  final sameSender = currentMsg['senderId'] == nextMsg['senderId'];

  final timeDiffInMinutes = DateTime.parse(
    nextMsg['timestamp'],
  ).difference(DateTime.parse(currentMsg['timestamp'])).inMinutes;

  final nextShowTime = timeDiffInMinutes > 2 || !sameSender;

  if (sameSender && !nextShowTime) {
    return false; // Still part of group → flat corner
  }

  return true; // End of group → rounded corner
}

Widget chatContainer({
  required BuildContext context,
  required Map<String, dynamic> msg,
  required bool isSender,
  required bool showTime,
  required int index,
  required bool showAvatarAndName,
  required List<Map<String, dynamic>> messages,
}) => Container(
  margin: EdgeInsets.only(top: showAvatarAndName ? 20 : 3),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: !isSender
        ? MainAxisAlignment.start
        : MainAxisAlignment.end,
    spacing: !isSender ? 10 : 0,
    children: [
      !isSender
          ? showAvatarAndName || showTime
                ? Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: CircleAvatar(
                      radius: 17,
                      backgroundImage: NetworkImage(msg['avatar']!),
                    ),
                  )
                : SizedBox(width: 34, height: 34)
          : SizedBox.shrink(),
      Column(
        crossAxisAlignment: !isSender
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          showAvatarAndName || showTime
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6,
                  ),
                  child: Row(
                    spacing: !isSender ? 10 : 0,
                    mainAxisAlignment: !isSender
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      !isSender
                          ? Text(
                              msg['name'],
                              style: appText(size: 13, weight: FontWeight.w400),
                            )
                          : SizedBox.shrink(),
                      Text(
                        AppFormatedTime.formattedTimestamp(msg['timestamp']),
                        style: appText(size: 11, weight: FontWeight.w400),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.5,
            ),

            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  !isSender
                      ? (!showTime && !showAvatarAndName)
                            ? 0
                            : 30
                      : 30,
                ),
                topRight: Radius.circular(
                  isSender
                      ? (!showTime)
                            ? 0
                            : 30
                      : 30,
                ),
                bottomLeft: Radius.circular(
                  !isSender
                      ? (shouldShowBottomLeftRadiusForCurrent(
                              index: index,
                              messages: messages,
                            ))
                            ? 30
                            : 0
                      : 30,
                ),
                bottomRight: Radius.circular(
                  isSender
                      ? shouldShowBottomRightRadiusForCurrent(
                              index: index,
                              messages: messages,
                            )
                            ? 30
                            : 0
                      : 30,
                ),
              ),

              color: !isSender ? Colors.grey[200] : Colors.blueGrey[300],
              // borderRadius: BorderRadius.circular(22),
            ),
            child: chatContent(
              msg,
              color: isSender ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    ],
  ),
);
