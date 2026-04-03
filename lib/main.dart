import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'favourite_page.dart';
import 'CartPage.dart';
import 'LoginScreen.dart' show LoginScreen;
import 'ProfileScreen.dart';
//import 'SearchPage.dart';
import 'SignUp.dart' show SignupScreen;
import 'WelcomeScreen.dart';
import 'homepage.dart';
import 'splashScreen.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseAuth.instance.signInAnonymously();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F5F8),
      ),
      initialRoute: "/", // Start at splash screen
      routes: {
        "/": (context) => splashScreen(),
        "welcome": (context) => WelcomeScreen(),
        "login": (context) => LoginScreen(),
        "signup": (context) => SignupScreen(),
        "home": (context) => homepage(),
        "cartPage": (context) => CartPage(),
        "account": (context) => ProfileScreen(),
        "favourite": (context) => FavouritePage(),

      },
    );
  }
}