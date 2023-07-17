import 'dart:convert';

import 'package:amazon_clone/common/constants/error_hanlders.dart';
import 'package:amazon_clone/common/constants/utils.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/screens/home.dart';

class AuthService {
  // sign up user
  void signUpUser({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        type: '',
        token: '',
      );

      var USER_URL = dotenv.env['base'];

      http.Response response = await http.post(
        Uri.parse('$USER_URL/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      if (context.mounted) {
        httpErrorHandlers(
          response: response,
          context: context,
          onSuccess: () {
            showCupertinoAlertDialog(
                context, 'Account created! Login with the same credentials');
          },
        );
      }
    } catch (e) {
      showCupertinoAlertDialog(context, e.toString());
    }
  }

  // sign in user
  void signInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      var USER_URL = dotenv.env['base'];

      http.Response response = await http.post(
        Uri.parse('$USER_URL/api/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      if (context.mounted) {
        httpErrorHandlers(
          response: response,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            // ignore: use_build_context_synchronously
            Provider.of<UserProvider>(context, listen: false)
                .setUser(response.body);
            await prefs.setString(
                'x-auth-token', jsonDecode(response.body)['token']);

            Navigator.pushNamedAndRemoveUntil(
              context,
              Home.routeName,
              (route) => false,
            );
          },
        );
      }
    } catch (e) {
      showCupertinoAlertDialog(context, e.toString());
    }
  }
}
