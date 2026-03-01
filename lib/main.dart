import 'package:flutter/material.dart';
import 'package:green/splashScreen.dart';


import 'CartPage.dart';
import 'ItemPage.dart';
import 'LoginScreen.dart' show LoginScreen;
import 'ProfileScreen.dart';
import 'SignUp.dart' show SignupScreen;
import 'WelcomeScreen.dart';
import 'homepage.dart';



void main() {
  runApp( MyHomePage ());
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
      },
    );
  }
}
