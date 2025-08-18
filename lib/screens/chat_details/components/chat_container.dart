import 'package:flutter/material.dart';

import '../../../core/font/app_font.dart';
import '../../../utils/time_formater.dart';
import '../widgets/chat_content.dart';

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
}) {
  final backgroundColor = !isSender ? Colors.grey[200]! : Colors.blueGrey[200]!;
  double dx = 0.0;

  return StatefulBuilder(
    builder: (context, setState) {
      const double maxDrag = 120;
      const double swipeThreshold = 80;

      void updateDx(double newDx) {
        setState(() {
          dx = newDx.clamp(-maxDrag, maxDrag);
        });
      }

      void snapBack() {
        setState(() {
          dx = 0.0;
        });
      }

      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (details) {
          updateDx(dx + details.delta.dx);
        },
        onHorizontalDragEnd: (_) {
          if (dx.abs() > swipeThreshold) {
            if (dx > 0) {
              debugPrint("➡️ Right swipe detected on message $index");
            } else {
              debugPrint("⬅️ Left swipe detected on message $index");
            }
          }
          snapBack();
        },
        onHorizontalDragStart: (_) {
          debugPrint("Horizontal drag started");
        },
        child: Transform.translate(
          offset: Offset(dx, 0),
          child: bubbleWidget(
            showAvatarAndName,
            isSender,
            showTime,
            msg,
            context,
            index,
            messages,
            backgroundColor,
          ), // <-- your chat bubble
        ),
      );
    },
  );
}

Widget bubbleWidget(
  bool showAvatarAndName,
  bool isSender,
  bool showTime,
  Map<String, dynamic> msg,
  BuildContext context,
  int index,
  List<Map<String, dynamic>> messages,
  Color backgroundColor,
) {
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
            ? showAvatarAndName || showTime
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20.0),
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
                                style: appText(
                                  size: 13,
                                  weight: FontWeight.w400,
                                ),
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

              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    !isSender
                        ? (!showTime && !showAvatarAndName)
                              ? 5
                              : 20
                        : 20,
                  ),
                  topRight: Radius.circular(
                    isSender
                        ? (!showTime)
                              ? 5
                              : 20
                        : 20,
                  ),
                  bottomLeft: Radius.circular(
                    !isSender
                        ? (shouldShowBottomLeftRadiusForCurrent(
                                index: index,
                                messages: messages,
                                // msg: msg['content'],
                              ))
                              ? 20
                              : 5
                        : 20,
                  ),
                  bottomRight: Radius.circular(
                    isSender
                        ? shouldShowBottomRightRadiusForCurrent(
                                index: index,
                                messages: messages,
                              )
                              ? 20
                              : 5
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
          ],
        ),
      ],
    ),
  );
}
