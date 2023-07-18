import 'package:amazon_clone/common/constants/global_variables.dart';
import 'package:amazon_clone/common/custom_button.dart';
import 'package:amazon_clone/features/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../../../common/custom_textfield.dart';

enum Auth { signIn, signUp }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  // route name
  static const String routeName = '/auth-screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signUp;

  final _signUpFormKey = GlobalKey<FormState>();

  final _signInFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final AuthService authService = AuthService();

  void signUpUser() {
    authService.signUpUser(
      context: context,
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );
  }

  void signInUser() {
    authService.signInUser(
      context: context,
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Build your dream world with us.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                tileColor: _auth == Auth.signUp
                    ? GlobalVariables.backgroundColor
                    : GlobalVariables.greyBackgroundCOlor,
                title: const Text(
                  'Create Account',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                leading: Radio(
                  value: Auth.signUp,
                  groupValue: _auth,
                  onChanged: (Auth? val) {
                    setState(() {
                      _auth = val!;
                    });
                  },
                  activeColor: GlobalVariables.secondaryColor,
                ),
              ),
              if (_auth == Auth.signUp)
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: GlobalVariables.backgroundColor,
                    child: Form(
                        key: _signUpFormKey,
                        child: Column(
                          children: [
                            CustomFormField(
                              hintText: 'Name',
                              labelText: 'Enter your name',
                              controller: nameController,
                              prefixIcon: const Icon(Icons.person),
                            ),
                            const SizedBox(height: 7),
                            CustomFormField(
                              controller: emailController,
                              labelText: 'Enter your email address',
                              hintText: 'Email',
                              prefixIcon: const Icon(Icons.email),
                            ),
                            const SizedBox(height: 7),
                            CustomFormField(
                              labelText: 'Enter password',
                              controller: passwordController,
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.password),
                            ),
                            const SizedBox(height: 10),
                            CustomButton(
                                text: 'Sign up', onTap: _submitFormSignUp),
                          ],
                        )),
                  ),
                ),
              ListTile(
                tileColor: _auth == Auth.signIn
                    ? GlobalVariables.backgroundColor
                    : GlobalVariables.greyBackgroundCOlor,
                title: const Text(
                  'Sign in',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                leading: Radio(
                  value: Auth.signIn,
                  groupValue: _auth,
                  onChanged: (Auth? val) {
                    setState(() {
                      _auth = val!;
                    });
                  },
                  activeColor: GlobalVariables.secondaryColor,
                ),
              ),
              if (_auth == Auth.signIn)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Form(
                    key: _signInFormKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        CustomFormField(
                          controller: emailController,
                          labelText: 'Enter your email address',
                          hintText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                        ),
                        const SizedBox(height: 10),
                        CustomFormField(
                          labelText: 'Enter password',
                          controller: passwordController,
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.password),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(text: 'Sign in', onTap: _submitFormSignIn),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String input) {
    // Regular expression to check email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(input);
  }

  bool isPasswordStrong(String input) {
    // Define your password strength criteria here
    bool hasUppercase = input.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = input.contains(RegExp(r'[a-z]'));
    bool hasDigits = input.contains(RegExp(r'[0-9]'));
    bool hasSpecialChars = input.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return input.length >= 8 &&
        hasUppercase &&
        hasLowercase &&
        hasDigits &&
        hasSpecialChars;
  }

  void _submitFormSignUp() {
    if (_signUpFormKey.currentState!.validate()) {
      signUpUser();
    }
  }

  void _submitFormSignIn() {
    if (_signInFormKey.currentState!.validate()) {
      _signInFormKey.currentState!.save();
      signInUser();
    }
  }
}
