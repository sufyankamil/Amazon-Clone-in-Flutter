import 'package:amazon_clone/common/bottom_bar.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/home/screens/category_screen.dart';
import 'package:amazon_clone/features/home/screens/home.dart';
import 'package:flutter/material.dart';

import 'common/constants/screen_not_found.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const AuthScreen(),
      );
    case Home.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const Home(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const BottomBar(),
      );
    case CategoryDealsScreen.routeName:
      var category = settings.arguments as String;
      return MaterialPageRoute(
          settings: settings,
          builder: (_) => CategoryDealsScreen(
                category: category,
              ));
    case AdminScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const AdminScreen(),
      );
    // case SearchScreen.routeName:
    //   var searchQuery = routeSettings.arguments as String;
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => SearchScreen(
    //       searchQuery: searchQuery,
    //     ),
    //   );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const AddProductScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const NoScreen(),
      );
  }
}
