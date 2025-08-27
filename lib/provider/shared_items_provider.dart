import 'package:flutter/material.dart';

import '../core/constants/messages.dart';

class SharedItemsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> get files =>
      messages.where((m) => m["type"] == "pdf").toList();

  List<Map<String, dynamic>> get links => messages
      .where(
        (m) => m["type"] == "text" && (m["content"] as String).contains("http"),
      )
      .toList();

  List<Map<String, dynamic>> get media =>
      messages.where((m) => m["type"] == "image").toList();
}
