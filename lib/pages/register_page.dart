// ignore_for_file: library_private_types_in_public_api, avoid_print, unused_local_variable, unused_label, unused_import, non_constant_identifier_names, use_build_context_synchronously, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:temp1/components/my_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';


class RegisterPage extends StatefulWidget 
{
  const RegisterPage({super.key});

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
  TextEditingController serverController = TextEditingController();
  TextEditingController portController = TextEditingController();

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



  /* **************** Network  F U N C T I O N ******************* */
  void SettingsLogin() 
  {
    showDialog
    (
      context: context,
      builder: (BuildContext context) 
      {
        return AlertDialog
        (
          title: const Text("Network Settings", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
          content: Column
          (
            mainAxisSize: MainAxisSize.min,
            children: 
            [
              const Text("Add Server and Port to Connect", style: TextStyle(color: Colors.white)),

              const SizedBox(height: 15),

              Container
              (
                height: 50,
                decoration: BoxDecoration
                (
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[800],
                ),

                child: TextFormField
                (
                  controller: serverController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration
                  (
                    labelText: 'Server',
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ),

              SizedBox(height: 16),

              Container
              (
                height: 50,
                decoration: BoxDecoration
                (
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[800],
                ),

                child: TextFormField
                (
                  controller: portController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration
                  (
                    labelText: 'Port',
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ),
            ],
          ),

          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

          actions: <Widget>
          [
            ElevatedButton
            (
              child: const Text("Save", style: TextStyle(color: Colors.black)),
              onPressed: () 
              {
                saveSettings(serverController.text, portController.text);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

void saveSettings(String server, String port) async 
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('server', server);
  await prefs.setString('port', port);
}

/* **************** Register F U N C T I O N ******************* */

void signUserUp() async
 {
  String userEmail = emailController.text;
  String userPassword = passwordController.text;
  String userPhoneNumber = phoneController.text;

  String passwordCrypted = cryptageData(userPassword);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String server = prefs.getString('server') ?? '192.168.178.16';
  String port = prefs.getString('port') ?? '5000';

  if (server.isEmpty || port.isEmpty) 
  {
    debugPrint('Server or port not specified in SharedPreferences');
    return;
  }

  if(userEmail.isEmpty && userPassword.isEmpty && userPhoneNumber.isEmpty)
  {
    await showstatus(context, "Warning", "Fields are required ", Icons.warning, Colors.red);
    return;
  }

  var signUpUrl = Uri.parse('http://$server:$port/signup');

  try 
  {
    var response = await http.post
    (
      signUpUrl,
      headers: 
      {
        'Content-Type': 'application/json'
      },
      body: jsonEncode
      (
        {
          'email': userEmail,
          'password': userPassword,
          'phone': userPhoneNumber,
        } 
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) 
    {
      print('User sign-up successful');

      await showstatus(context, "Success", "Sign-up Succesfully", Icons.check_circle_rounded, Colors.green);


      Future.delayed(Duration(seconds: 3), () 
      {
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
      });
    }

    else 
    {
      await showstatus(context, "Failed", "Sign up Failed ${response.statusCode}", Icons.check_circle_rounded, Colors.green);

      debugPrint('User sign-up failed with status (user already exist): ${response.statusCode}');
    }
  } 
  catch (e) 
  {
    debugPrint('Error: $e');
  }
}

    /* **************** L O G I N   F U N C T I O N ******************* */

  void signUserIn() 
  {
    Navigator.pushNamed(context, '/loginpage');
  }

        Future<bool?> showstatus(BuildContext context , String title , String msg , IconData icon , Color color) 
        {
        return showDialog<bool>
        (
          context: context,
          builder: (BuildContext context) 
          {
            return AlertDialog(
              title: Text(title , textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 50,
                    color: color,
                  ),
                  SizedBox(height: 20),
                  Text(msg),
                ],
              ),
            );
          },
        );
      }

  @override
  Widget build(BuildContext context) 
  {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Container
    (
      height: screenHeight,
      width: screenWidth,
      
      child: Scaffold
      (
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFF080a16),
      
        body: SingleChildScrollView
        (
          child: SafeArea
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
                    GestureDetector
                    (
                      onTap: SettingsLogin,
                      child: const Row
                      (
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: 
                        [
                          Padding
                          (
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                            child: Icon(Icons.settings,color: Colors.white,size: 35),
                          ),
                        ],
                      ),
                    ),
          
          
                    const SizedBox(height: 20),
          
          
           /* **************** L O G O : S B M  ******************* */
          
                    Container
                    (
                        width: screenWidth-100,
                        height: 120,
                        decoration: BoxDecoration
                        (
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
          
                      child: Center
                      (
                        /* **************** L O G O : S B M  ******************* */
                        child: Image.asset
                        (
                          'images/logo_sheidt.png',
                          height: 180,
                          width: 180,
                        ),
                      ),
                    ),
          
                    const SizedBox(height: 20),
          
                        /* **************** T E X T : Register to Know more ******************* */
          
                    Text
                    (
                      "Register to know more",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
          
                    const SizedBox(height: 20),
          
                        /* **************** F I E L D : Email ******************* */
          
                    SizedBox
                    (
                      height: 50,
                      width: screenWidth-70,
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
                      height: 50,
                      width: screenWidth-70,
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
                      height: 50,
                      width: screenWidth-70,
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
                      height: 50,
                      width: screenWidth-70,
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
                      wb: screenWidth,
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
                              style: TextStyle(color: Colors.white),
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
                      wb: screenWidth,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
