import 'dart:async';

import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> animationCompleted = useState(false);

    useEffect(() {
      final animationTimer = Timer(const Duration(seconds: 3), () {
        animationCompleted.value = true;
        Future.delayed(const Duration(seconds: 3), () {
          animationCompleted.value = true;
          Navigator.pushNamedAndRemoveUntil(
            context,
            AuthScreen.routeName,
            (route) => false,
          );
        });
      });
      return () {
        animationTimer.cancel();
      };
    }, []);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
            AnimatedOpacity(
              opacity: animationCompleted.value ? 0 : 1,
              duration: const Duration(milliseconds: 500),
              child: Center(
                child: Image.asset(
                  'assets/images/amazon_in.png',
                  width: 400,
                  height: 300,
                  color: Colors.black,
                ),
              ),
            ),
              if (animationCompleted.value)
          LottieBuilder.asset(
            'assets/images/animationss.json',
            height: double.infinity,
            width: double.infinity,
            onLoaded: (composition) {},
          ),
        ],
      ),
    );
  }
}
