import 'package:amazon_clone/common/bottom_bar.dart';
import 'package:amazon_clone/common/constants/global_variables.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/router.dart';
import 'package:amazon_clone/splash/splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'features/admin/screens/admin_screen.dart';

void main() async {
  await dotenv.load();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child:
          const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    authService.fetchUserData(context);
    checkServerConnectivity();
  }

  void checkServerConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isConnected = (connectivityResult != ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(_isConnected);
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazon Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      onGenerateRoute: ((settings) => generateRoute(settings)),
      home: _isConnected
          ? Provider.of<UserProvider>(context).user.token.isNotEmpty
              ? Provider.of<UserProvider>(context).user.type == 'user'
                  ? const BottomBar()
                  : const AdminScreen()
              : const SplashScreen()
          : buildNoServerConnectionMessage(),
    );
  }

  Widget buildNoServerConnectionMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: const Text(
        'Unable to connect to the server.\nPlease check your internet connection and try again.',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}



// import 'package:amazon_clone/common/bottom_bar.dart';
// import 'package:amazon_clone/common/constants/global_variables.dart';
// import 'package:amazon_clone/features/auth/services/auth_service.dart';
// import 'package:amazon_clone/providers/user_provider.dart';
// import 'package:amazon_clone/router.dart';
// import 'package:amazon_clone/splash/splash_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:provider/provider.dart';

// import 'features/admin/screens/admin_screen.dart';

// void main() async {
//   await dotenv.load();
//   runApp(MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (context) => UserProvider(),
//         ),
//       ],
//       child:
//           const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp())));
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   showLoadingDialog(BuildContext context) {
//     showCupertinoDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return const CupertinoAlertDialog(
//           title: Text('Loading'),
//           content: CupertinoActivityIndicator(),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final AuthService authService = AuthService();

//     return FutureBuilder<void>(
//       future: authService.fetchUserData(context),
//       builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // Show a loading indicator if user data is being fetched.
//           return const SplashScreen();
//         } else if (snapshot.hasError) {
//           // Show an error message if there's an error in fetching user data.
//           return buildNoServerConnectionMessage(context);
//         } else {
//           // Continue with the regular navigation based on user data.
//           return MaterialApp(
//               debugShowCheckedModeBanner: false,
//               title: 'Amazon Clone',
//               theme: ThemeData(
//                 scaffoldBackgroundColor: GlobalVariables.backgroundColor,
//                 colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//                 useMaterial3: true,
//                 appBarTheme: const AppBarTheme(
//                   elevation: 0,
//                   iconTheme: IconThemeData(
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               onGenerateRoute: ((settings) => generateRoute(settings)),
//               home: Provider.of<UserProvider>(context).user.token.isNotEmpty
//                   ? Provider.of<UserProvider>(context).user.type == 'user'
//                       ? const BottomBar()
//                       : const AdminScreen()
//                   : const SplashScreen());
//         }
//       },
//     );
//   }

//   Widget buildNoServerConnectionMessage(BuildContext context) {
//     return Scaffold(
//       backgroundColor: GlobalVariables.backgroundColor,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: Colors.grey[200],
//               ),
//               child: const Text(
//                 'Unable to connect to the server.\nPlease check your internet connection and try again.',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               // Navigate back to the SplashScreen to check if connection is back.
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const SplashScreen(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
