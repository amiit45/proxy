import 'package:flutter/material.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/chat/screens/chat_screen.dart';

class Routes {
  static const String auth = '/';
  static const String home = '/home';
  static const String chat = '/chat';
}

final Map<String, WidgetBuilder> appRoutes = {
  Routes.auth: (context) => AuthScreen(),
  Routes.home: (context) => HomeScreen(),
  Routes.chat: (context) => ChatScreen(),
};