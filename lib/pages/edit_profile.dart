// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:temp1/components/my_button.dart';

class EditProfile extends StatefulWidget 
{
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
} 

class _EditProfileState extends State<EditProfile> 
{
  void Edit() 
  {
    Navigator.pushNamed(context, '/welcomepage');
    print('Button Clicked');
  }

  void Back_to_Main() 
  {
    Navigator.pushNamed(context, '/welcomepage');
    print('Button Clicked');
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],

      appBar: AppBar
      (
        title: const Text
        (
          "Forgot Password",
          style: 
            TextStyle
            (
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          
          backgroundColor: Colors.grey[300],
          centerTitle: true,
          leading: GestureDetector
          (
            onTap: Back_to_Main, 
            child: const Icon
            (
              Icons.arrow_back,
              color: Colors.black,
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

              Text
              (
                "Enter your Email ",
                style: TextStyle(color: Colors.grey[850], fontSize: 20),
              ),

              const SizedBox(height: 20),

              /* **************** F I E L D : Email ******************* */
              SizedBox(
                height: 70,
                width: 350,

                child: TextFormField
                (
                  //controller: emailController,

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
                onTap: Edit, 
                textButton: 'Update Profile', 
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