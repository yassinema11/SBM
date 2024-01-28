// ignore_for_file: library_private_types_in_public_api, avoid_print, non_constant_identifier_names, unused_import, unused_local_variable, use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temp1/components/my_button.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class LoginPage extends StatefulWidget 
{
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> 
{
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberUser = false;
  bool isObscure = true;

  @override
  void initState() 
  {
    super.initState();
    loadRememberUser();
    checkAndSignIn();
  }

    /* **************** Check and SignIN  F U N C T I O N ******************* */
  Future<void> checkAndSignIn() 
  async 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSavedCredentials = prefs.getBool('rememberUser') ?? false;

    if (hasSavedCredentials) 
    {
      String userEmail = prefs.getString('userEmail') ?? '';
      String userPassword = prefs.getString('userPassword') ?? '';

      if (userEmail.isNotEmpty && userPassword.isNotEmpty) 
      {
        emailController.text = userEmail;
        passwordController.text = userPassword;

        signUserIn();
      }
    }
  }

  /* **************** SaveUserData  F U N C T I O N ******************* */

  void saveUserCredentials(String userEmail, String userPassword) 
  async 
  {
    String emailCrypted = cryptageData(userEmail);
    String passwordCrypted = cryptageData(userPassword);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userEmail', emailCrypted);
    prefs.setString('userPassword', passwordCrypted);
  }

  Future<void> loadRememberUser() async 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() 
    {
      rememberUser = prefs.getBool('rememberUser') ?? false;
    });
  }

  /* **************** C R Y P T A G E   F U N C T I O N ******************* */

  String cryptageData(String input) 
  {
    return md5.convert(utf8.encode(input)).toString();
  }

  /* **************** H T T P RQ F U N C T I O N ******************* */

  /*Future<void> postData() async
  {      
    final url = Uri.parse('https://liger-divine-surely.ngrok-free.app'); 
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'name': 'John Doe', 'email': 'john@example.com'});
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) 
    {
      print('Data Sending Success.');
    } 
    else 
    {
      print('Error: ${response.statusCode}');
    }
  }*/

  
  Future<void> Database ()
  async 
  {
      var db = await mongo.Db.create("mongodb+srv://sbm2024:sbm2024_projet@cluster0.pud7wkc.mongodb.net/");
      await db.open();
  }

 /* **************** L O G I N  F U N C T I O N ******************* */
  void signUserIn()
  async 
  {
    String userEmail = emailController.text;
    String userPassword = passwordController.text;

    String emailCrypted = cryptageData(userEmail);
    String passwordCrypted = cryptageData(userPassword);

    try 
    {
      var db = await mongo.Db.create
      (
        "mongodb+srv://sbm2024:sbm2024_projet@cluster0.pud7wkc.mongodb.net/");
        await db.open();

        var collection = db.collection('users');

        var user = await collection.findOne(mongo.where.eq('email', emailCrypted));

        if (user != null && user['password'] == passwordCrypted) 
        {
          Navigator.pushNamed
          (
            context,
            '/welcomepage',
            arguments: 
            {
              'email': userEmail,
              'password': userPassword,
              'rem': rememberUser.toString(),
            },
          );
        }
        else 
        {
          debugPrint('User not found or password incorrect');
        }

        await db.close();
    } 
    catch (e) 
    {
      debugPrint('Error connecting to the database: $e');
    }
  }


  /* **************** R E G I S T E R  F U N C T I O N ******************* */
  void signUserUp() 
  {
    Navigator.pushNamed(context, '/registerpage');
  }


  /* **************** Password forget  F U N C T I O N ******************* */
  void PassForget() 
  {
      String userEmail = emailController.text;

      Navigator.pushNamed
      (
        context,
        '/forgotpassword',
        arguments: 
        {
          'email': userEmail,
        },
      );
  }



  @override
  Widget build(BuildContext context) 
  {
    Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null && arguments.containsKey('email') && arguments.containsKey('password')) 
    {
      emailController.text = arguments['email'];
      passwordController.text = arguments['password'];
    }

      /* **************** S C A F F O L D ******************* */

    return Scaffold
    (
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF080a16),


  /* **************** B O D Y  ******************* */
      body: SafeArea
      (
        child: Form
        (
          key: form,
          autovalidateMode: AutovalidateMode.always,
          child: Center
          (
            child: Column
            (
              children: 
              [
                const SizedBox(height: 50),
                Container
                (
                    width: 300,
                    height: 150,
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
                      height: 200,
                      width: 200,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                
                
        /* **************** T E X T : WELCOME BACK ******************* */

                const Text
                (
                  " Welcome Back ",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),

                const SizedBox(height: 20),

        /* **************** F I E L D : EMAIL ******************* */

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
                      labelStyle: const TextStyle(color: Colors.black),

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



                      hintStyle: const TextStyle(color: Colors.black),

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
                    obscureText: isObscure,

                    validator: (value) 
                    {
                      if (value?.isEmpty ?? true) 
                      {
                        return 'Password is required';
                      }

                      return null;
                    },

                    decoration: InputDecoration
                    (
                      labelText: 'Password',
                      floatingLabelBehavior:FloatingLabelBehavior.auto,
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
                            isObscure = !isObscure;
                          });
                        },

             /* **************** I C O N : Show / Hide ******************* */

                        icon: Icon
                        (
                          isObscure
                              ? Icons.visibility_off
                              : Icons.visibility,

                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

        /* **************** R A W  ******************* */
                Row
                (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: 
                  [
                    Row
                    (
                      children: 
                      [
                      /* **************** C H E C K B O X ******************* */
                        Checkbox
                        (
                          value: rememberUser,
                          onChanged: (value) 
                          {
                            setState(() 
                            {
                              rememberUser = value!;
                            });
                          },
                        ),
                        const Text
                        (
                          "Remember me",
                            style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),

                    const SizedBox(width: 70),

                    /* **************** T E X T  B U T T O N  ******************* */
                    TextButton
                    (
                      onPressed: () 
                      {
                        PassForget();
                      },
                      child: const Text("I forgot my password",style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),


    //bgColor: 0xFF080a16
    //btn : 
    //      1/ 0xFF810cf5 *** 2/ 0xFF810cf5 *** 3/ 0xFFa64efc 

    // box : 0xFF141931
                const SizedBox(height: 30),
                
                /* **************** L O G I N  B U T T O N  ******************* */
                MyButton
                (
                  onTap: signUserIn,
                  textButton: 'L  O  G  I  N ',
                  hb: 50,
                  wb: 350,
                ),

                const SizedBox(height: 15),
                

        /* **************** O R  B L O C K  ******************* */

                const Padding
                (
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row
                  (
                    children: 
                    [
                      Expanded
                      (
                        child: Divider
                        (
                          thickness: 0.5,
                          color: Colors.white,
                        ),
                      ),
                      Padding
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
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                /* **************** R E G I S T E R   B U T T O N ******************* */

                MyButton
                (
                  onTap: signUserUp,
                  textButton: 'R  E  G  I  S  T  E  R ',
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
