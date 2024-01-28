// ignore_for_file: library_private_types_in_public_api, avoid_print, unused_local_variable, unused_label, unused_import, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:temp1/components/my_button.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget 
{
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> 
{
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confpasswordController = TextEditingController();

  bool isObscureP = true;
  bool isObscureCP = true;

  @override
  void initState() 
  {
    super.initState();
  }

  /* **************** C R Y P T A G E   F U N C T I O N ******************* */

  String cryptageData(String input) 
  {
    return md5.convert(utf8.encode(input)).toString();
  }



/* **************** R E G I S T E R  F U N C T I O N ******************* */
void signUserUp() async 
{
  String userEmail = emailController.text;
  String userPassword = passwordController.text;
  String userPhoneNumber = phoneController.text;

  String emailCrypted = cryptageData(userEmail);
  String phoneNumberCrypted = cryptageData(userPhoneNumber);
  String passwordCrypted = cryptageData(userPassword);

  try 
  {
    var db = await mongo.Db.create("mongodb+srv://sbm2024:sbm2024_projet@cluster0.pud7wkc.mongodb.net/");
    await db.open();

    var usersCollection = db.collection('users'); 

    var existingUser = await usersCollection.findOne(mongo.where.eq('email', emailCrypted));

    if (existingUser == null) 
    {
      await usersCollection.insert
      (
        {
        'email': emailCrypted,
        'password': passwordCrypted,
        'phone': phoneNumberCrypted,
        }
      );

      Navigator.pushNamed
      (
        context,
        '/loginpage',
        arguments:
        {
          'email': userEmail,
          'password': userPassword,
        },
      );
    } 
    else 
    {
      debugPrint('User with the same email already exists');
    }
    await db.close();
  } 
  catch (e) 
  {
    debugPrint('Error connecting to the database: $e');
  }
}


    /* **************** L O G I N    F U N C T I O N ******************* */

  void signUserIn() 
  {
    Navigator.pushNamed(context, '/loginpage');
  }


  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea
      (
        child: Form
        (
          key: form,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Center
          (
            child: Column
            (
              children: 
              [
                const SizedBox(height: 30),

       /* **************** L O G O : S B M  ******************* */

                Center
                (
                  child: Image.asset
                  (
                    'images/logo_sheidt.png',
                    height: 200,
                    width: 350,
                  ),
                ),

                const SizedBox(height: 20),

                    /* **************** T E X T : Register to Know more ******************* */

                Text
                (
                  "Register to know more",
                  style: TextStyle(color: Colors.grey[850], fontSize: 20),
                ),

                const SizedBox(height: 20),

                    /* **************** F I E L D : Email ******************* */

                SizedBox
                (
                  height: 70,
                  width: 350,
                  child: TextFormField
                  (

                    keyboardType: TextInputType.emailAddress,                    
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
                
                const SizedBox(height: 10),

        /* **************** F I E L D : Phone Number ******************* */

                SizedBox
                (
                  height: 70,
                  width: 350,
                  child: TextFormField
                  (
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    validator: (value) 
                    {
                      if (value?.isEmpty ?? true) 
                      {
                        return 'Phone Number is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration
                    (
                      labelText: 'Phone Number',
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

                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

    /* **************** F I E L D : Password ******************* */

                SizedBox
                (
                  height: 70,
                  width: 350,
                  child: TextFormField
                  (
                    controller: passwordController,
                    obscureText: isObscureP,

                    validator: (value) 
                    {
                      if (value?.isEmpty ?? true) 
                      {
                        return 'Password is required';
                      }

                      else if (value!.length < 8) 
                      {
                        return 'Password must be at least 8 characters long';
                      }
                      
                      return null;
                    },
                    decoration: InputDecoration
                    (
                      labelText: 'Password',
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

                      suffixIcon: IconButton
                      (
                        onPressed: () 
                        {
                          setState(() 
                          {
                            isObscureP = !isObscureP;
                          });
                        },

                   /* **************** I C O N : Show / Hide ******************* */

                        icon: Icon
                        (
                          isObscureP
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                

             /* **************** F I E L D : Confirm Password ******************* */

                SizedBox
                (
                  height: 70,
                  width: 350,
                  child: TextFormField
                  (
                    controller: confpasswordController,
                    obscureText: isObscureCP,

                    validator: (value) 
                    {
                      if (value?.isEmpty ?? true) 
                      {
                        return 'Password is required';
                      } 

                      else if (value != passwordController.text)
                      {
                        return 'Password do not match';
                      }

                      else if (value!.length < 8) 
                      {
                        return 'Password must be at least 8 characters long';
                      }

                      return null;
                    },

                    
                    decoration: InputDecoration
                    (
                      labelText: 'Confirm Password',
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

                      suffixIcon: IconButton
                      (
                        onPressed: () 
                        {
                          setState(() 
                          {
                            isObscureCP = !isObscureCP;
                          });
                        },

               /* **************** I C O N : Show / Hide ******************* */

                        icon: Icon
                        (
                          isObscureCP
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                
      /* **************** R E G I S T E R  B U T T O N ******************* */

                MyButton
                (
                  onTap: signUserUp,
                  textButton: 'R  E  G  I  S  T  E  R ',
                  hb: 50,
                  wb: 350,
                ),

                const SizedBox(height: 15),

        /* **************** O R  B L O C K  ******************* */

                Padding
                (
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row
                  (
                    children: 
                    [
                      Expanded
                      (
                        child: Divider
                        (
                          thickness: 0.5,
                          color: Colors.grey[700],
                        ),
                      ),
                      const Padding
                      (
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text
                        (
                          'Or ',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Expanded
                      (
                        child: Divider
                        (
                          thickness: 0.5,
                          color: Colors.grey[700],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 15),

          /* **************** L O G I N  B U T T O N ******************* */

                MyButton
                (
                  onTap: signUserIn,
                  textButton: 'L  O  G  I  N ',
                  hb: 50,
                  wb: 350,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
