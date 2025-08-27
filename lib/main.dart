import 'package:chat_system/screens/chat_list/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/chat_details_provider.dart';
import 'provider/chat_search_provider.dart';

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
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pink,
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
