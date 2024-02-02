// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:temp1/components/my_button.dart';

class ForgotPassword extends StatefulWidget 
{
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> 
{
  final TextEditingController emailController = TextEditingController();

  void test() 
  {
    debugPrint('test');
  }


    /* **************** BACK TO LOGIN  F U N C T I O N ******************* */
  void ToLogin() 
  {
    Navigator.pushNamed(context, '/loginpage');
  }

  @override
  Widget build(BuildContext context) 
  {

    Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null && arguments.containsKey('email')) 
    {
      emailController.text = arguments['email'];
    }


    return Scaffold
    (
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF080a16),

      appBar: AppBar
      (
        backgroundColor: const Color(0xFF080a16),
        title: const Text
        (
          "Forgot Password",
          style: 
            TextStyle
            (
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
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
                style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
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
                    
                    else if (!value!.contains('@')) 
                    {
                      return 'Invalid email format';
                    }

                    return null;
                  },

                  decoration: InputDecoration
                  (
                    labelText: 'Email',

                    enabledBorder: const OutlineInputBorder
                    (
                      borderSide: BorderSide(color: Colors.white),
                    ),

                    focusedBorder: const OutlineInputBorder
                    (
                      borderSide: BorderSide(color: Colors.white),
                    ),

                    fillColor: Colors.grey.shade200,
                    filled: true,

                    focusedErrorBorder: const OutlineInputBorder
                    (
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              MyButton
              (
                onTap: test, 
                textButton: 'Send', 
                hb: 50, 
                wb: 250,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
