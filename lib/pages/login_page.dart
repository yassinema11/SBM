// ignore_for_file: library_private_types_in_public_api, avoid_print, non_constant_identifier_names, unused_import, unused_local_variable, use_build_context_synchronously, unused_element, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temp1/components/my_button.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';

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

  TextEditingController serverController = TextEditingController();
  TextEditingController portController = TextEditingController();

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
    String passwordCrypted = cryptageData(userPassword);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userEmail', userEmail);
    prefs.setString('userPassword', passwordCrypted);
  }

  Future<void> loadRememberUser() async 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() 
    {
      rememberUser = prefs.getBool('rememberUser') ?? true;
    });
  }

  /* **************** C R Y P T A G E   F U N C T I O N ******************* */

  String cryptageData(String input) 
  {
    return md5.convert(utf8.encode(input)).toString();
  }

  void saveUserData(String userEmail, String userPass, String Id) async 
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('id', Id);
    pref.setString('user', userEmail);
    pref.setString('password', userPass);
  }
  
 /* **************** L O G I N  F U N C T I O N ******************* */

 void signUserIn() async 
 {
  String userEmail = emailController.text;
  String userPassword = passwordController.text;
  String userID='0';


  if(userEmail.isEmpty && userPassword.isEmpty)
  {
    QuickAlert.show
    (
      context: context,
      type: QuickAlertType.error,
      textColor:Colors.white,
      text: 'Please add your email and password',
      backgroundColor: Colors.black,
    );
    return;
  }

  else
  {
    String passwordCrypted = cryptageData(userPassword);
    String Sign = "signin";

    try 
    {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String server = prefs.getString('server') ?? '192.168.178.16';
      String port = prefs.getString('port') ?? '5000';

      if (server.isEmpty || port.isEmpty) 
      {
        debugPrint('Server or port not specified in SharedPreferences');
        return;
      }

      var signInUrl = Uri.parse('http://$server:$port/$Sign');

      var response = await http.post
      (
        signInUrl,
        headers: 
        {
          'Content-Type': 'application/json'
        }, 
        body: jsonEncode
        (
          {
            '_id': userID,
            'email': userEmail, 
            'password': userPassword,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) 
      {
        var responseData = jsonDecode(response.body);
  
        // Extract the user ID from the response
        var userId = responseData['userId'];
        userID = userId;
        
        // Print the user ID in the debugger
        print('User ID: $userID');

        print('------------------------');

        saveUserData(userEmail,passwordCrypted,userID);
        print('id $userID');

        QuickAlert.show
        (
          context: context,
          type: QuickAlertType.success,
          text: 'Welcome . . . ',
          showConfirmBtn:false,	
          backgroundColor: Colors.black,
        );

        Future.delayed(Duration(seconds: 1), () 
        {
          Navigator.pushNamed
          (
            context,
            '/welcomepage',
          );
        });

      } 
      else 
      {
        debugPrint('User not found or password incorrect');
        
        QuickAlert.show
        (
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          textColor:Colors.white,
          titleColor: Colors.white,
          text: 'Check your user or password',
          backgroundColor: Colors.black,
        );
      }
    } 
    catch (e) 
    {
      debugPrint('Error: $e');
    }
  }
}


  void saveSettings(String server, String port) async 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('server', server);
    await prefs.setString('port', port);
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

  void SettingsLogin() 
  {
    showDialog
    (
      context: context,
      builder: (BuildContext context) 
      {
        return AlertDialog
        (
          title: const Text
          (
            "Network Settings", 
            style: TextStyle(color: Colors.white), 
            textAlign: TextAlign.center,
          ),

          content: Column
          (
            mainAxisSize: MainAxisSize.min,
            children: 
            [
              const Text
              (
                "Add Server and Port to Connect", 
                style: TextStyle(color: Colors.white)
              ),

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

          backgroundColor: Colors.black,
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


  @override
  Widget build(BuildContext context) 
  {
    Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null && arguments.containsKey('email')) 
    {
      emailController.text = arguments['email'];
      passwordController.text = arguments['password'];
    }


      /* **************** S C A F F O L D ******************* */

    return Scaffold
    (
      resizeToAvoidBottomInset: true, 
      backgroundColor: const Color(0xFF080a16),


      /* **************** B O D Y  ******************* */
      body: SingleChildScrollView
      (
        child: SafeArea
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
        
                  const SizedBox(height: 40),
        
                  Container
                  (
                      width: MediaQuery.of(context).size.width-100,
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
        
                const SizedBox(height: 40),
                  
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
                    width: MediaQuery.of(context).size.width-60,
                    child: TextFormField
                    (
                      controller: emailController,
                      validator: (value) 
                      {
                        if (value?.isEmpty ?? true)
                        {
                          return 'Email is required';
                        }
        
                        /*
                        else if (!value!.contains('@')) 
                        {
                          return 'Invalid email format';
                        }
                        */
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
                    width: MediaQuery.of(context).size.width-60,
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
                      SizedBox
                      (
                        width: MediaQuery.of(context).size.width-200,
                        child: Row
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
                      ),
        
                      const SizedBox(width: 30),
        
                      /* **************** T E X T  B U T T O N : forget password  ******************* */
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
            
                  const SizedBox(height: 25),
                  
                  /* **************** L O G I N  B U T T O N  ******************* */
                  MyButton
                  (
                    onTap: signUserIn,
                    textButton: 'L  O  G  I  N ',
                    hb: 50,
                    wb: MediaQuery.of(context).size.width,
                  ),
        
                  const SizedBox(height: 15),
                  
        
                  /* **************** O R  B L O C K  ******************* */
        
                  Padding
                  (
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    
                    child: SizedBox
                    (
                      
                      width: MediaQuery.of(context).size.width-20,

                      child: Row
                      (
                        children: 
                        const 
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
                  ),
        
                  const SizedBox(height: 15),
        
                  /* **************** R E G I S T E R   B U T T O N ******************* */
        
                  MyButton
                  (
                    onTap: signUserUp,
                    textButton: 'R  E  G  I  S  T  E  R ',
                    hb: 50,
                    wb: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
