import 'package:amazon_clone/common/constants/error_hanlders.dart';
import 'package:amazon_clone/common/constants/utils.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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

      print(USER_URL);

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
}
