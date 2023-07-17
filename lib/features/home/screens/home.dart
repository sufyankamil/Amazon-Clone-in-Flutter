import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  // route name
  static const String routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Welcome to the app'),
            Text(userData.toJson()),
          ],
        ),
      ),
    );
  }
}
