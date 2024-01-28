import 'package:flutter/material.dart';
import 'package:temp1/pages/edit_profile.dart';
import 'package:temp1/pages/forgot_password.dart';
import 'package:temp1/pages/login_page.dart';
import 'package:temp1/pages/register_page.dart';
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
  const MyApp
  (
    {
      super.key
    }
  );

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp
    (
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),

      routes: 
      {
        '/loginpage': (context) => const LoginPage(),
        '/registerpage': (context) =>  const RegisterPage(),
        '/welcomepage': (context) => const WelcomePage(),
        '/forgotpassword': (context) => const ForgotPassword(),
        '/editprofile': (context) => const EditProfile(),

      },
    );
  }
}

