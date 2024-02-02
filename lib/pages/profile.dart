// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, unnecessary_null_comparison, non_constant_identifier_names, unused_local_variable, unused_element

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget 
{

  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile>
{
  late String mailuser = "email";

  late String name = "Name";
  late String mail = "Email";
  late String phone = "Phone";
  late List<Map<String, dynamic>> lpns = [];
  

  @override
  void initState() 
  {
    super.initState();
    ProfileData();
  }
  

  void Logout() 
  {
    Navigator.pushNamed(context, '/loginpage');
  }

  Future<void> ProfileData() async 
  {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Em = prefs.getString('user');

    
      try 
      {
        if (Em == null) 
        {
          print('User email is null');
          return;
        }


        SharedPreferences prefs = await SharedPreferences.getInstance();
        String server = prefs.getString('server') ?? '192.168.178.16';
        String port = prefs.getString('port') ?? '5000';

        final userUrl = 'http://$server:$port/user?email=$Em';
        //final lpnsUrl = 'http://$server:$port/lpns';

        final response = await http.get
        (
          Uri.parse(userUrl),
          headers: <String, String>
          {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );


        if (response.statusCode == 200 || response.statusCode == 201) 
        {
          final userData = jsonDecode(response.body);

          setState(() 
          {
            name = userData['name'];
            mail = userData['email'];
            phone = userData['phone'];
          });
        } 
        else if (response.statusCode == 404) 
        {
          print("User not found");
        } 
        else 
        {
          print("Failed to load user data: ${response.statusCode}");
        }

        /*final lpnsResponse = await http.get
        (
          Uri.parse(lpnsUrl),
          headers: <String, String>
          {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );*/

        /*if (lpnsResponse.statusCode == 200) 
        {
          final lpnsData = jsonDecode(lpnsResponse.body);

          setState(()
          {
            lpns = List<Map<String, dynamic>>.from(lpnsData);
          });
        }
        else 
        {
          print("Failed to load lpns data: ${lpnsResponse.statusCode}");
        }*/
      } 
      catch (e) 
      {
        print('Error fetching user data: $e');
      }
  }

  void Update() 
  {
    Navigator.pushNamed(context, '/editprofile');
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF080a16),

      body: Column
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
                      //onTap: Logout,
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
            );
  }
}