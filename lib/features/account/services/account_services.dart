import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/constants/utils.dart';
import '../../auth/screens/auth_screen.dart';

class AccountServices {
  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AuthScreen.routeName,
          (route) => false,
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
