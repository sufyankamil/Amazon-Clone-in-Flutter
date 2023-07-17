import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/home/screens/home.dart';
import 'package:flutter/material.dart';

import 'common/constants/screen_not_found.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
          settings: settings, builder: (_) => const AuthScreen());
    case Home.routeName:
      return MaterialPageRoute(
          settings: settings, builder: (_) => const Home());
    default:
      return MaterialPageRoute(
          settings: settings, builder: (_) => const NoScreen());
  }
}
