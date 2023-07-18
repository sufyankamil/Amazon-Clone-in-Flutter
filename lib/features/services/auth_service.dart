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

import '../../common/bottom_bar.dart';
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

      var userUrl = dotenv.env['base'];

      http.Response response = await http.post(
        Uri.parse('$userUrl/api/signup'),
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
              context,
              'Account created! Login with the same credentials',
              'Success',
            );
          },
        );
      }
    } catch (e) {
      showCupertinoAlertDialog(
        context,
        'Unable to connect to server! Please try again after sometime',
        'Alert',
      );
    }
  }

  // sign in user
  void signInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      var userUrl = dotenv.env['base'];

      http.Response response = await http.post(
        Uri.parse('$userUrl/api/signin'),
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

            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                BottomBar.routeName,
                (route) => false,
              );
            }
          },
        );
      }
    } catch (e) {
      showCupertinoAlertDialog(context, 'Alert',
          'Unable to connect to server! Please try again after sometime');
    }
  }

  // fetch user's data
  void fetchUserData(
    BuildContext context,
  ) async {
    try {
      var userUrl = dotenv.env['base'];

      SharedPreferences preferences = await SharedPreferences.getInstance();

      String? token = preferences.getString('x-auth-token');

      if (token == null) {
        preferences.setString('x-auth-token', '');
      }

      var tokenResponse = await http.post(
        Uri.parse('$userUrl/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenResponse.body);

      if (response == true) {
        // fetch user
        http.Response result = await http.get(
          Uri.parse('$userUrl/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(result.body);
      }
    } catch (e) {
      showCupertinoAlertDialog(context, 'Alert', e.toString());
    }
  }
}
