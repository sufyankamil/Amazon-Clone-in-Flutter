import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> animationCompleted = useState(false);

    // Forward the animation when the widget is built
    useEffect(() {
      Future.delayed(const Duration(seconds: 3), () {
        animationCompleted.value = true;
        Navigator.pushNamedAndRemoveUntil(
              context,
              AuthScreen.routeName,
              (route) => false,
            );
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          LottieBuilder.asset(
            'assets/images/animationss.json', 
            height: double.infinity,
            width: double.infinity,
            onLoaded: (composition) {
              // Set up an event listener for animation completion
              // composition.addStatusListener((status) {
              //   if (status == AnimationStatus.completed) {
              //     animationCompleted.value = true;
              //   }
              // });
            },
          ),
          Center(
            child: AnimatedOpacity(
              opacity: animationCompleted.value ? 0 : 1,
              duration: const Duration(milliseconds: 500),
              child: const FlutterLogo(
                size: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
