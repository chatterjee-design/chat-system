import 'package:flutter/material.dart';

class ConversationOptionProvider extends ChangeNotifier {
  bool historyOn = true;
  bool isMuted = false;
  bool notificationsOn = true;

  void toggleHistory() {
    historyOn = !historyOn;
    notifyListeners();
  }

  void toggleMute() {
    isMuted = !isMuted;
    notifyListeners();
  }

  void toggleNotifications() {
    notificationsOn = !notificationsOn;
    notifyListeners();
  }
}
