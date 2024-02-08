// ignore_for_file: avoid_print, unused_local_variable, non_constant_identifier_names, deprecated_member_use, unused_import, file_names, avoid_unnecessary_containers, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
//import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget 
{
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> 
{
  bool isScanning = false;
  late String Blt;
  bool isBluetoothConnected = false;
  BeaconBroadcast beaconBroadcast = BeaconBroadcast();



  @override
  void initState() 
  {
    super.initState();
    BltStat();
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

  Future<void> openGate() async 
  { 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('id');

    if (!isBluetoothConnected) 
    {
      // Display an alert to turn on Bluetooth
      await showDialog
      (
        context: context,
        builder: (BuildContext context) 
        {
          return AlertDialog
          (
            backgroundColor: Colors.black,
            title: const Text('Bluetooth OFF', style: TextStyle(color: Colors.white)),
            content: const Text('Turn it ON?', style: TextStyle(color: Colors.white)),
            actions: 
            [
              TextButton
              (
                onPressed: () 
                {
                  Navigator.of(context).pop();
                },
              
                child: const Text('No', style: TextStyle(color: Colors.white)),
              ),

              TextButton
              (
                onPressed: () async 
                {
                  // Close the alert dialog
                  Navigator.of(context).pop();
                  // Turn on Bluetooth
                  //await FlutterBlue.instance.isOn;
                },
                child: const Text('Yes', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    }
    else
    {
      try 
      {

        print('BLE Broadcasting...');
        String cid = 'SBM'; // Company ID
        String? Uid = uid;  // user ID from the database 


        // Start broadcasting the beacon signal
        await beaconBroadcast
            .setUUID('$cid-$Uid-441A-802F-9C398FC199D2')
            .setMajorId(1)
            .setMinorId(100)
            .start();
        
        print('BLE Signal Sent Successfully with the user id --- $uid');
      } 
      catch (e) 
      {
        print('Error Broadcasting BLE Signal: $e');
      }

        /*
          final customSignalData = [0x00, 0x00, 0x00, 0x00];

          final eddystoneFrame = EddystoneUidFrame
          (
            namespaceId: [0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF], 
            instanceId: customSignalData,
          );
        */
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF080a16),
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
              "Welcome",
              style: TextStyle
              (
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF080a16),
            centerTitle: true,
          ),
          const SizedBox(height: 20),
          Center
          (
            child: Container
            (
              width: 350,
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
                  SizedBox(width: 150),
                  Text(
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
              const Padding
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
              'images/main.png',
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
                  gradient: const RadialGradient
                  (
                    radius: 1,
                    colors: <Color>
                    [                      
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Color(0xFF810cf5),                                     
                      Color.fromARGB(255, 149, 97, 202),                      
                      Colors.transparent,
                      Color.fromARGB(255, 149, 97, 202), 
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding
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
        ],
      ),
    );
  }
}

class EddystoneUidFrame 
{
  final List<int> namespaceId;
  final List<int> instanceId;

  EddystoneUidFrame({required this.namespaceId, required this.instanceId});

  List<int> get frameBytes 
  {
    final byteList = Uint8List(18);
    byteList[0] = 0x00;  
    byteList.setAll(1, namespaceId);
    byteList.setAll(11, instanceId);
    return byteList;
  }
}
