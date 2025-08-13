import 'package:chat_system/screens/chat_list/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/chat_details_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ChatDetailsProvider())],
      child: MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.indigo,
        ),
        darkTheme: ThemeData.dark(),
        home: ChatListScreen(),
      ),
    );
  }
}
