import 'package:chat_system/modules/search_chat/presentation/screens/chat_search_screen.dart';
import 'package:chat_system/modules/shared/presentation/screens/shared_screen.dart';
import 'package:chat_system/modules/starred_chat/presentation/screens/starred_msg_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/conversation_details_provider.dart';

class ConversationOptionScreen extends StatelessWidget {
  const ConversationOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConversationOptionProvider(),
      child: Consumer<ConversationOptionProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,

            appBar: AppBar(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerLow,

              title: const Text("Conversation options"),
            ),
            body: ListView(
              children: [
                OptionItem(
                  icon: Icons.folder_shared_outlined,
                  title: "Shared resources",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SharedScreen()),
                    );
                  },
                ),
                OptionItem(
                  icon: Icons.history,
                  title: "History is on",
                  subtitle:
                      "Saves new messages (for a period set by your organisation)",
                  isSwitch: true,
                  switchValue: provider.historyOn,
                  onSwitchChanged: (_) => provider.toggleHistory(),
                ),
                OptionItem(
                  icon: Icons.search,
                  title: "Search in conversation",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChatSearchScreen()),
                    );
                  },
                ),
                OptionItem(
                  icon: Icons.markunread_outlined,
                  title: "Mark as unread",
                  onTap: () {},
                ),
                OptionItem(
                  icon: Icons.star_border,
                  title: "Starred messages",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StarredMsgScreen(),
                      ),
                    );
                  },
                ),
                OptionItem(
                  icon: provider.isMuted
                      ? Icons.volume_off
                      : Icons.volume_up_outlined,
                  title: provider.isMuted ? "Unmute" : "Mute",
                  onTap: provider.toggleMute,
                ),
                OptionItem(
                  icon: Icons.notifications,
                  title: "Notifications",
                  isSwitch: true,
                  switchValue: provider.notificationsOn,
                  onSwitchChanged: (_) => provider.toggleNotifications(),
                ),
                const Divider(),
                OptionItem(icon: Icons.report, title: "Report", onTap: () {}),
                OptionItem(
                  icon: Icons.delete,
                  title: "Delete conversation",
                  textColor: Colors.red,
                  onTap: () {},
                ),
                OptionItem(
                  icon: Icons.block,
                  title: "Block",
                  textColor: Colors.red,
                  onTap: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Reusable option item widget
class OptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final Color? textColor;

  const OptionItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isSwitch) {
      return SwitchListTile(
        secondary: Icon(icon, color: textColor),
        title: Text(title, style: TextStyle(color: textColor)),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        value: switchValue,
        onChanged: onSwitchChanged,
      );
    }

    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: onTap,
    );
  }
}
