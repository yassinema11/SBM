// ignore_for_file: non_constant_identifier_names, prefer_const_declarations, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, sized_box_for_whitespace

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temp1/components/my_button.dart';

class ForgotPassword extends StatefulWidget 
{
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> 
{
  final TextEditingController emailController = TextEditingController();

  void ToLogin() 
  {
    Navigator.pushNamed(context, '/loginpage');
  }

  void sendVerificationEmail(String email, String code) async 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String server = prefs.getString('server') ?? '192.168.178.16';
    String port = prefs.getString('port') ?? '5000';

    if (server.isEmpty || port.isEmpty) 
    {
      debugPrint('Server or port not specified in SharedPreferences');
      return;
    }

    String send = "send_email";
    var apiUrl = Uri.parse('http://$server:$port/$send');

    final response = await http.post
    (
      apiUrl,
      body: json.encode
      (
      {
        'email': email,
        'code': code,
      }),
      headers: <String, String>
      {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) 
    {
      debugPrint('Email sent successfully to $email');
    } 
    else 
    {      
      debugPrint('Failed to send email: ${response.statusCode}');
    }
  }

  void Reset() 
  {
    String email = emailController.text;
    String code = generateRandomCode();
    sendVerificationEmail(email, code);

    showDialog
    (
      context: context,
      builder: (BuildContext context) 
      {
        return AlertDialog
        (
          title: const Text('Enter Verification Code'),
          content: TextField
          (
            onChanged: (enteredCode) 
            {
              VerifyCode(enteredCode, code);
            },
            decoration: const InputDecoration(labelText: 'Verification Code'),
          ),
          actions: <Widget>
          [
            TextButton(
              onPressed: () 
              {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton
            (
              onPressed: () 
              {
                VerifyCode('', code);
              },
              child: const Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  void VerifyCode(String enteredCode, String generatedCode) 
  {
    if (enteredCode == generatedCode)
    {
      // The entered code matches the generated code
      showDialog
      (
        context: context,
        builder: (BuildContext context) 
        {
          return AlertDialog
          (
            title: const Text('Verification Successful'),
            content: const Text('You have successfully verified your email.'),
            actions: <Widget>
            [
              TextButton
              (
                onPressed: () 
                {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } 
    else 
    {
      // The entered code does not match the generated code
      showDialog
      (
        context: context,
        builder: (BuildContext context) 
        {
          return AlertDialog
          (
            title: const Text('Verification Failed'),
            content: const Text('The verification code you entered is incorrect.'),
            actions: <Widget>
            [
              TextButton
              (
                onPressed: () 
                {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  String generateRandomCode() 
  {
    final random = Random();
    const chars = '0123456789';
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) 
  {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null && arguments.containsKey('email')) 
    {
      emailController.text = arguments['email'];
    }

    return Container
    (
      height: screenHeight,
      width: screenWidth,
      
      child: Scaffold
      (
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF080a16),
        appBar: AppBar
        (
          backgroundColor: const Color(0xFF080a16),
          title: const Text
          (
            "Forgot Password",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          centerTitle: true,
          leading: GestureDetector
          (
            onTap: ToLogin,
            child: const Icon
            (
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        body: SafeArea
        (
          child: Center
          (
            child: Column
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
              [
                const SizedBox(height: 30),
                const Text
                (
                  "Enter your Email ",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
      
                /* **************** F I E L D : Email ******************* */
                SizedBox
                (
                  height: 70,
                  width: 350,
                  child: TextFormField
                  (
                    controller: emailController,
                    validator: (value) 
                    {
                      if (value?.isEmpty ?? true) 
                      {
                        return 'Email is required';
                      } 
                      /*else if (!value!.contains('@'))
                      {
                        return 'Invalid email format';
                      }*/
                      return null;
                    },
      
                    decoration: InputDecoration
                    (
                      labelText: 'Email',
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                MyButton
                (
                  onTap: Reset,
                  textButton: 'Send',
                  hb: 50,
                  wb: 250,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
