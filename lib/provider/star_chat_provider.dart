import 'package:flutter/material.dart';

import '../core/constants/messages.dart';

class StarChatProvider extends ChangeNotifier {
  List<Map<String, dynamic>> get starredMessages =>
      messages.where((msg) => msg["isStar"] == true).toList();

  List<Map<String, dynamic>> get textMessages => starredMessages
      .where((msg) => msg["type"] == "text" && !containsLink(msg["content"]))
      .toList();

  List<Map<String, dynamic>> get resourceMessages => starredMessages
      .where((msg) => msg["type"] != "text" || containsLink(msg["content"]))
      .toList();

  bool containsLink(String text) {
    final linkRegex = RegExp(
      r'((https?:\/\/)?([\w-]+\.)+[a-zA-Z]{2,}(\S*)?)',
      caseSensitive: false,
    );
    return linkRegex.hasMatch(text);
  }
}
