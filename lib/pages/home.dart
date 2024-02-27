// ignore_for_file: avoid_print, unused_local_variable, non_constant_identifier_names, deprecated_member_use, unused_import, file_names, avoid_unnecessary_containers, use_build_context_synchronously, unnecessary_const, prefer_const_constructors, prefer_adjacent_string_concatenation, unused_element, unnecessary_type_check, unnecessary_null_comparison, sized_box_for_whitespace, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget 
{
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> 
{
  bool isScanning = false;
  late String Blt;
  bool isBluetoothConnected = false;
  BeaconBroadcast beaconBroadcast = BeaconBroadcast();
  String selectedLanguage = 'English';
  bool isDarkMode = true;

  @override
  void initState() 
  {
    super.initState();
    BltStat();
    loadSet();
  }

  Future<void> BltStat() async 
  {
    try 
    {
      if (!(await FlutterBluePlus.isAvailable)) 
      {
        print("Bluetooth is not available on this device");
        return;
      }

      if (!(await FlutterBluePlus.isOn)) 
      {
        print("Bluetooth is not turned on");
        return;
      }

      setState(() 
      {
        isBluetoothConnected = true;
      });
    } 
    catch (e) 
    {
      print("Error connecting to device: $e");
    }
  }    
  
    bool isValidUUID(String? uuid) 
    {
      if (uuid == null) return false;
      final pattern = RegExp
      (
          r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',caseSensitive: false
      );  
      return pattern.hasMatch(uuid);
    }
    
  Future<void> openGate() async 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('ui');

    print('id: $id');

    if (id != null) 
    {
      try 
      {
        int myInt = int.tryParse(id) ?? 0; 
        String hexString = myInt.toRadixString(16); 
        String Cid = 'F8';

        print('Hex String: $hexString');

        String uuid = 'F838'+'$hexString'+'F-0101-0000-F850-9C398FC199D2';

        //String uuid = 'F83261ef01010000f850';

        String u = 'F83261ef-0101-0000-f850';
        print('Generated UUID: $uuid');

        bool isValid = isValidUUID(uuid);

        if (!isValid) 
        {
          try 
          {
            beaconBroadcast
                .setUUID(uuid)
                .setMajorId(1)
                .setMinorId(100)
                .start();

            print('--------------------------------BLE Signal Advertised --------------------------------------');

            ScaffoldMessenger.of(context).showSnackBar
            (
              SnackBar
              (
                content: Text('Opening Barrier . . . '),
                duration: const Duration(seconds: 3),
              ),
            );    

            ScaffoldMessenger.of(context).showSnackBar
            (
              SnackBar
              (
                content: Text(' Barrier Opened '),
                duration: const Duration(seconds: 2),
              ),
            );    
          } 
          catch (e) 
          {
            print('*************************** Error Broadcasting BLE Signal: $e ********************************');
          }
        } 
        else 
        {
          print('**************************************** Invalid UUID: $uuid ********************************');
        }
      } 
      catch (e) 
      {
        print('Error: $e');
      }
    } 
    else 
    {
      print('ID not found in SharedPreferences');
    }
  }

  /*Future<void> OpenGate() async 
  {

    try 
    {
      beaconBroadcast
        .setUUID('39ED98FF-2900-441A-802F-9C398FC199D2')
        .setMajorId(1)
        .setMinorId(100)
        .setLayout('m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24')
        .setManufacturerId(0x004c)
        .start();

      ScaffoldMessenger.of(context).showSnackBar
      (
        SnackBar
        (
          content: Text('Sent Succesfully'),
        ),
      );    
    } 
    catch (e) 
    {
      print('Failed to start beacon advertising: $e');
      ScaffoldMessenger.of(context).showSnackBar
    (
      SnackBar
      (
        content: Text('Failed'),
      ),
    );    
  }



    /*
    final customSignalData = [0x00, 0x00, 0x00, 0x00];
    final eddystoneFrame = EddystoneUidFrame
    (
      namespaceId: [0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF], 
      instanceId: customSignalData,
    );
    */

    print('BLE Signal Sent Successfully');
  }*/


  Future<void> loadSet() async 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(()
    {
      selectedLanguage = prefs.getString('language')?? 'English';
      print(isDarkMode);
      isDarkMode = prefs.getBool('darkMode')?? true;
    });
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
        resizeToAvoidBottomInset: false,
        backgroundColor: isDarkMode ? const Color(0xFF080a16) : Colors.white,
        
        body: Column
        (
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: 
          [
            AppBar
            (
              automaticallyImplyLeading: false,
              title: Text
              (
                "Welcome",
      
                style: TextStyle
                (
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: isDarkMode? Colors.white : Colors.black,
                ),
              ),
      
              backgroundColor: isDarkMode ? const Color(0xFF080a16) : Colors.white,
              centerTitle: true,
            ),
      
            const SizedBox(height: 20),
      
            Center
            (
              child: Container
              (
                width: 300,
                height: 60,
                decoration: BoxDecoration
                (
                  color: const Color(0xFFA367B1),
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
      
                    SizedBox(width: 100),
      
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
      
          const SizedBox(height: 40),
      
            Row
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
              [
                Center
                (
                  child: Image.asset
                  (
                    isBluetoothConnected ? 'images/Connected.png' : 'images/not_connected.png',
                    width: 25,
                    height: 25,
                  ),
                ),
                Padding
                (
                  padding: const EdgeInsets.all(10.0),
                  child: Text
                  (
                    'Bluetooth :',
                    style: TextStyle
                    (
                      fontSize: 22,
                      color: isDarkMode ? Colors.white : Colors.black,          
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
      
                const SizedBox(width: 10),
      
                Text
                (
                  isBluetoothConnected ? 'Connected' : 'Not connected',
                  style: TextStyle
                  (
                    color: isBluetoothConnected ? Colors.green : Colors.red,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
      
            const SizedBox(height: 50),
      
            Center
            (
              child: Image.asset
              (
                isDarkMode ? 'images/main.png' : 'images/main_img.png',
                width: 200,
                height: 200,
              ),
            ),
      
            const SizedBox(height: 40),
      
            Center
            (
              child: GestureDetector
              (
                onTap: openGate,
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
                      colors: isDarkMode
                      ? [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Color(0xFF810cf5),
                        ]
                      : [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Color(0xFF810cf5),
                        ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding
                  (
                    padding: const EdgeInsets.all(15.0),
                    child: Text
                    (
                      'Click to OPEN',
                      style: TextStyle
                      (
                        color: isDarkMode ? Colors.white : Colors.black,          
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
