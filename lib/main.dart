import 'package:chat_system/modules/chat_list/chat_list_screen.dart';
import 'package:chat_system/provider/conversation_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/chat_details_provider.dart';
import 'provider/chat_search_provider.dart';
import 'provider/shared_items_provider.dart';
import 'provider/star_chat_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatDetailsProvider()),
        ChangeNotifierProvider(create: (_) => ChatSearchProvider()),
        ChangeNotifierProvider(create: (_) => SharedItemsProvider()),
        ChangeNotifierProvider(create: (_) => StarChatProvider()),
        ChangeNotifierProvider(create: (_) => ConversationOptionProvider()),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            brightness: Brightness.dark,
          ),
        ),
        home: ChatListScreen(),
      ),
    );
  }
}
