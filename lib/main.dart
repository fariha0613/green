import 'package:flutter/material.dart';
import 'package:green/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


import 'CartPage.dart';
import 'ItemPage.dart';
import 'LoginScreen.dart' show LoginScreen;
import 'ProfileScreen.dart';
import 'SearchPage.dart';
import 'SignUp.dart' show SignupScreen;
import 'WelcomeScreen.dart';
import 'homepage.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData(
        scaffoldBackgroundColor: Color(0xFFF7F5F8)
      ),
      debugShowCheckedModeBanner: false,
      routes:{
        "/":(context)=>splashScreen(),
        "welcome":(context)=>WelcomeScreen(),
        "login":(context)=>LoginScreen(),
        "signup":(context)=>SignupScreen(),
        "home":(context)=>homepage(),
        "itemPage":(context)=>Itempage(),
        "cartPage":(context)=>CartPage(),
        "account":(context)=> ProfileScreen(),
        "search":(context)=>SearchPage(),
      },
    );
  }
}
