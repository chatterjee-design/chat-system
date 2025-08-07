import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../core/font/app_font.dart';
import '../../../utils/time_formater.dart';
import 'chat_content.dart';

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
                              // msg: msg['content'],
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
