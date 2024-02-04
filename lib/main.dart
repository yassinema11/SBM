// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:temp1/pages/Home.dart';
import 'package:temp1/pages/forgot_password.dart';
import 'package:temp1/pages/login_page.dart';
import 'package:temp1/pages/profile.dart';
import 'package:temp1/pages/register_page.dart';
import 'package:temp1/pages/settings.dart';
import 'package:temp1/pages/welcome_page.dart';

void main() 
{
  runApp
  (
    const MyApp()
  );
}

class MyApp extends StatelessWidget 
{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp
    (
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),

      theme: ThemeData
      (
        // Define your theme here
        // Example:
        // primaryColor: Colors.blue,
        // accentColor: Colors.green,
      ),

      routes: 
      {
        '/loginpage': (context) => const LoginPage(),
        '/registerpage': (context) => const RegisterPage(),
        '/welcomepage': (context) => WelcomePage(),
        '/forgotpassword': (context) => const ForgotPassword(),
        '/profile': (context) => const Profile(),
        '/home': (context) => const Home(),
        '/settings': (context) => const Settings(),
      },
    );
  }
}
