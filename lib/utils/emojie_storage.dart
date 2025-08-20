import 'package:shared_preferences/shared_preferences.dart';

class EmojiStorage {
  static const String _key = "recent_emojis";

  static Future<List<String>> getRecentEmojis() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? ["😂", "😍", "👍", "🔥", "🤝"];
  }

  static Future<void> addEmoji(String emoji) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> emojis =
        prefs.getStringList(_key) ?? ["😂", "😍", "👍", "🔥", "🤝"];

    emojis.remove(emoji);

    if (emojis.length >= 5) {
      emojis.removeAt(0);
    }

    emojis.add(emoji);
    await prefs.setStringList(_key, emojis);
  }
}
