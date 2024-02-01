// ignore_for_file: avoid_unnecessary_containers, non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, sized_box_for_whitespace, unused_element, use_build_context_synchronously, unused_local_variable, unused_import, unnecessary_null_comparison

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  int currentIndex = 1;
  PageController pageController = PageController(initialPage: 1);
  late String UE = "tester";
  late String name = "Name";
  late String mail = "Email";
  late String phone = "Phone";

  @override
  void initState() {
    super.initState();
    initializeUserProfileData();
  }

  Future<void> initializeUserProfileData() async {
    print('Initializing user profile data...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('user');

    if (userEmail != null) {
      await updateProfileData(userEmail);
    } else {
      print('User email is null');
    }

    // Initialize UE here with a default value if it's still not set
    if (UE.isEmpty) {
      UE = "Default User";
      print('Initialized UE with default value: $UE');
    }
  }

  List<Map<String, dynamic>> lpns = [
    {
      'icon': Icons.directions_car,
      'iconColor': Color(0xFF5e3b91),
      'plateNumber': '1234 TU 55',
    }
  ];

  void Logout() {
    Navigator.pushNamed(context, '/loginpage');
  }

  void OpenGate() {
    print('Button Clicked');
  }

  void Update() {
    Navigator.pushNamed(context, '/editprofile');
  }

  Future<void> updateProfileData(String userEmail) async {
    try {
      if (userEmail == null) {
        print('User email is null');
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String server = prefs.getString('server') ?? '192.168.178.16'; // Default server if not found
      String port = prefs.getString('port') ?? '5000'; // Default port if not found

      final url = 'http://$server:$port/user?email=$userEmail';
      print(userEmail);
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        setState(() {
          // Update state with user data
          name = userData['name'] ?? 'test'; // Check for null and provide default value
          mail = userData['email'] ?? 'aaaa'; // Check for null and provide default value
          phone = userData['phone'] ?? '11111'; // Check for null and provide default value

          print(name);
          print(mail);
          print(phone);
        });
      } else if (response.statusCode == 404) {
        // User not found
        print("User not found");
      } else {
        // Other HTTP errors
        print("Failed to load user data: ${response.statusCode}");
      }
    } catch (e) {
      // Catch any exceptions that occur during the HTTP request
      print('Error fetching user data: $e');
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Context is null: ${context == null}');

    bool dataLoaded = name.isNotEmpty && mail.isNotEmpty && phone.isNotEmpty;
    if (!dataLoaded) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (pageController != null && context != null) {
      try {
      return Scaffold
    (
      resizeToAvoidBottomInset: false,
      
      
      backgroundColor: Color(0xFF080a16),
    
      body: PageView
      (
        controller: pageController,
        children: <Widget>
        [
    
            /* **************** C O N T A I N E R : PROFILE PAGE ******************* */
          Container
          (
            key: Key('Profile'),
            child: Column
            (
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: 
              [
                AppBar
                (
                  automaticallyImplyLeading: false,
                  title: const Text
                  (
                      "Profile",
                        style: TextStyle
                        (
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
          
                      backgroundColor: Color(0xFF080a16),
                      centerTitle: true,
                    ),
          
                  const SizedBox(height:30),
          
                    Center
                    (
                      child: Container
                      (
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration
                        (
                          shape: BoxShape.circle,
                          
                        ),
                        child: Padding
                        (
                          padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                          child: ClipRRect
                          (
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset
                            (
                              'images/logo.jpeg',
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                const SizedBox(height:20),
          
                Center
                (
                  child: Container
                  (
                    width: 350,
                    height: 40,
                    decoration: BoxDecoration
                    (
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                
                    child: Row
                    (
                      
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: 
                      [
                        SizedBox(width:15),
          
                        Padding
                        (
                          padding: EdgeInsets.zero,
                          child: Icon(Icons.person, color: Color(0xFF5e3b91),),
                        ),
          
                            SizedBox(width:15),
                
                          Container
                          (
                            alignment: Alignment.center,
                            child: Text
                            (
                              name,
                              style: TextStyle
                              (
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          
                const SizedBox(height:20),
          
                Center
                (
                  child: Container
                  (
                    width: 350,
                    height: 40,
                    decoration: BoxDecoration
                    (
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                
                    child: Row
                    (
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: 
                      [
                        SizedBox(width:15),
          
                        Icon(Icons.mail, color: Color(0xFF5e3b91),),
                
                          SizedBox(width:15),
                
                          Text
                          (
                            mail,
                            style: TextStyle
                            (
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          
                  const SizedBox(height:20),
          
                Center
                (
                  child: Container
                  (
                    width: 350,
                    height: 40,
                    decoration: BoxDecoration
                    (
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                
                    child: Row
                    (
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: 
                      [
                        SizedBox(width:15),
          
                        Icon(Icons.phone, color: Color(0xFF5e3b91),),
                
                            SizedBox(width:15),
                
                          Text
                          (
                            phone,
                            style: TextStyle
                            (
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          
          
                Center
                (
                child: Container
                (
                  height: 90,
                  width: 350, 
                  child: ListView.builder
                  (
                    itemCount: lpns.length,
                    itemBuilder: (BuildContext context, int index) 
                    {
                      return Container
                      (
                        width: 350,
                        height: 40,
                        margin: EdgeInsets.symmetric(vertical: 3),
          
                        decoration: BoxDecoration
                        (
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
          
                        child: Row
                        (
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: 
                          [                                                    
                            SizedBox(width:15),
          
                            Icon
                            (
                              lpns[index]['icon'],
                              color: lpns[index]['iconColor'],
                            ),
          
                            SizedBox(width: 10),
          
                            Text
                            (
                              lpns[index]['plateNumber'],
                              style: TextStyle
                              (
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
          
                const SizedBox(height:60),
          
                Center
                (
                  child: GestureDetector
                  (
                    onTap: Logout,
                    child: Container
                    (
                      width: 200,
                      height: 60,
                      alignment: Alignment.center,
                      
                      decoration: BoxDecoration
                      (
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        gradient: RadialGradient
                        (
                          radius: 1,
                          
                          colors: <Color>
                          [
                            Color.fromARGB(255, 149, 97, 202),
                            Color(0xFF810cf5),
                            Color(0xFFa64efc),
                          ]
                        ),
                      ),
                    
                      child: Padding
                      (
                        padding: EdgeInsets.all(15.0),
                        child: Text
                        (
                          'Logout ',
                          style: TextStyle
                          (
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),   
              ],
            ),
          ),


    
    /* **************** C O N T A I N E R : HOME PAGE ******************* */
          Container
          (
            child: Column
            (
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: 
              [
                AppBar
                (
                  automaticallyImplyLeading: false,
                  title: const Text
                  (
                    "Welcome",
                    style: TextStyle
                    (
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Color(0xFF080a16),
                  centerTitle: true,
                ),
    
                const SizedBox(height:30),
    
                Center
                (
                  child: Container
                  (
                    width: 350,
                    height: 60,
                    decoration: BoxDecoration
                    (
                      color: Color(0xFFA367B1),
                      borderRadius: BorderRadius.circular(20),
                    ),
      
                    child: const Row
                    (
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: 
                      [
                        Padding
                        (
                          padding: EdgeInsets.all(15.0),
                          child: Text
                          (
                            'Free Places',
                            style: TextStyle
                            (
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
      
                            SizedBox(width:150),
      
                          Text
                          (
                            '00',
                            style: TextStyle
                            (
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
    
             const SizedBox(height:50),
    
                Row
                (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: 
                  [  
                    Center
                    (
                      child: Image.asset
                      (
                          'images/Connected.png',
                          width: 25,
                          height: 25,
                      ),
                    ),             
                    
                      Padding
                      (
                        padding: EdgeInsets.all(10.0),
                        child: Text
                        (
                          'Bluetooth :',
                          style: TextStyle
                          (
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    
                        SizedBox(width:10),
                    
                      Text
                      (
                        'Connected',
                        style: TextStyle
                        (
                          color: Colors.green,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),

    
                Row
                (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: 
                  [  
                    Center
                    (
                      child: Image.asset
                      (
                          'images/not_connected.png',
                          width: 25,
                          height: 25,
                      ),
                    ),             
                    
                      Padding
                      (
                        padding: EdgeInsets.all(10.0),
                        child: Text
                        (
                          'BLE :',
                          style: TextStyle
                          (
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    
                        SizedBox(width:10),
                    
                      Text
                      (
                        'Not in range',
                        style: TextStyle
                        (
                          color: Colors.red,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),


                const SizedBox(height:70),
    
                Center
                (
                  child: Image.asset
                    (
                      'images/main.png',
                        width: 200,
                        height: 200,
                    ),
                ),
    
                  const SizedBox(height: 50),
    
                Center
                (
                  child: GestureDetector
                  (
                    onTap: OpenGate,
                    child: Container
                    (
                      width: 200,
                      height: 100,
                      alignment: Alignment.center,
                      
                      decoration: BoxDecoration
                      (
                        gradient: RadialGradient
                        (
                          radius: 1,
                          
                          colors: <Color>
                          [
                            Color.fromARGB(255, 149, 97, 202),
                            Color(0xFF810cf5),
                            Color(0xFFa64efc),
                          ]
                        ),
                      
                        borderRadius: BorderRadius.circular(20),
                      ),
                    
                      child: Padding
                      (
                        padding: EdgeInsets.all(15.0),
                        child: Text
                        (
                          'Click to OPEN',
                          style: TextStyle
                          (
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),   
    
                const SizedBox(height: 30),
    
                /*Column
                (
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:
                  [
                    Text
                    (
                      'Parking FULL',
                      style: TextStyle
                      (
                        color: Colors.red,
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                      
                    Text
                    (
                      'Another Comment',
                      style: TextStyle
                      (
                        color: Colors.yellow[800],
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                
                    Text
                    (
                      'Hellllo',
                      style: TextStyle
                      (
                        color: Colors.green[600],
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),*/      
              ],
            ),
          ),
    

          /* **************** C O N T A I N E R : SETTINGS PAGE ******************* */

          Container
          (
            child: AppBar
            (
              automaticallyImplyLeading: false,
              title: const Text
              (
                "Settings",
                style: TextStyle
                (
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Color(0xFF080a16),
              centerTitle: true,
            ),

          ),
        ],
      

        onPageChanged: (int index) 
        {
          setState(() 
          {
            currentIndex = index;
          });
        },
      ),
    
      bottomNavigationBar: CurvedNavigationBar
      (
        height: 50,
        index: currentIndex,
        buttonBackgroundColor: Color(0xFFFFD1E3),
        backgroundColor: Colors.transparent,
        
        items: const 
        [
          Icon(Icons.person, color: Color(0xFF5e3b91),),
          Icon(Icons.home,color: Color(0xFF5e3b91)),
          Icon(Icons.settings,color: Color(0xFF5e3b91)),
        ],
        animationDuration: const Duration(milliseconds: 10),
        animationCurve: Curves.easeInOut,
    
        onTap: (index) 
        {
          setState(() 
          {
            currentIndex = index;
            pageController.jumpToPage(index);
          });
        },

        letIndexChange: (index) => true,

      ),
    );
    } 
    catch (e) 
    {
      print('Error initializing PageView: $e');
      return Center
      (
        child: Text('Error occurred. Please try again.'),
      );
    }
    } 
    else 
    {
    // Handle case when pageController or context is null
    return Center
      (
        child: Text('Error: Page controller or context is null.'),
    );
  }
  }
  }
