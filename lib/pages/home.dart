// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, avoid_print, deprecated_member_use, unused_import, avoid_function_literals_in_foreach_calls, unnecessary_null_comparison

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Home extends StatefulWidget 
{
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}


class HomeState extends State<Home> 
{
  bool isScanning = false;
  BluetoothDevice? connectedDevice;

  @override
  void initState() 
  {
    super.initState();
    BLT();
  }

  Future<void> connectToDevice(BluetoothDevice device) async 
  {
    try 
    {
      // Connect to the device
      await device.connect();
      print('Connected to ${device.name}');

      // Store the connected device
      connectedDevice = device;

      // After connecting, send a specific UID (replace with your UID data)
      await _sendCustomSignal();

      // Listen to connection state changes
      var connectionSubscription = connectedDevice!.connectionState.listen((state) 
      {
        if (state == BluetoothConnectionState.disconnected) 
        {
          // Handle device disconnected
          print("Device disconnected");
        }
      });

      // Cancel the subscription to prevent duplicate listeners
      connectedDevice!.cancelWhenDisconnected(connectionSubscription,
          delayed: true, next: true);
    } 
    catch (e) 
    {
      print("Error connecting to device: $e");
    }
  }

  void OpenGate() async 
  {
    try 
    {
      // Check if the connected device is not null
      if (connectedDevice == null)
      {
        print('No device connected');
        return;
      }

      // Send a specific UID to the connected device
      await _sendCustomSignal();
    } 
    catch (e) 
    {
      print('Error opening gate: $e');
    }
  }

  Future<void> BLT() async 
  {
    if (!(await FlutterBluePlus.isSupported)) 
    {
      debugPrint("Bluetooth not supported by this device");
      return;
    }

    // Listen to Bluetooth adapter state changes
    var subscription = FlutterBluePlus.adapterState.listen((state) 
    {
      print(state);
      if (state == BluetoothAdapterState.on) 
      {
        // Start scanning for devices
        scan();
      } 
      else 
      {
        debugPrint("Error SCAN");
        // Handle Bluetooth adapter state off
      }
    });

    // Turn on Bluetooth for Android (for iOS, user controls Bluetooth state)
    if (Platform.isAndroid) 
    {
      await FlutterBluePlus.turnOn();
    } 
    else 
    {
      print('Please manually enable Bluetooth in your device settings.');
    }

    // Cancel the subscription to prevent duplicate listeners
    subscription.cancel();
  }

  Future<void> scan() async 
  {
    setState(() 
    {
      isScanning = true;
    });

    var subscription = FlutterBluePlus.onScanResults.listen((results) 
    {
      for (ScanResult r in results) 
      {
        print('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
        // Connect to a specific device when found
        if (r.device.name == "Bluno") 
        {
          connectToDevice(r.device);
        }
      }
    }, onError: (e) => print(e));

    FlutterBluePlus.cancelWhenScanComplete(subscription);
  }

  Future<void> _sendCustomSignal() async 
  {
    // Generate your custom signal data (replace with your data)
    final customSignalData = [0x12, 0x34, 0x56, 0x78];

    // Create an Eddystone UID frame with your custom signal data
    final eddystoneFrame = EddystoneUidFrame
    (
      namespaceId: [0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF], // Example namespace ID
      instanceId: customSignalData, // Use your custom signal data as the instance ID
    );

    try 
    {
      // Discover services and characteristics
      List<BluetoothService> services = await connectedDevice!.discoverServices();

      // Find the write characteristic
      BluetoothCharacteristic? writeCharacteristic;
      services.forEach((service) 
      {
        service.characteristics.forEach((characteristic) 
        {
          if (characteristic.properties.write) {
            writeCharacteristic = characteristic;
          }
        });
      });

      // If write characteristic is found, write the Eddystone UID frame to it
      if (writeCharacteristic != null) 
      {
        await writeCharacteristic!.write(eddystoneFrame.frameBytes);
        print('BLE Signal Sent Successfully');
      } 
      else 
      {
        print('Write characteristic not found');
      }
    } 
    catch (e) 
    {
      print('Error sending BLE signal: $e');
    }
  }


  @override
  Widget build(BuildContext context) 
  {
    return  Scaffold
    (
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF080a16),

          body:Column
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
                        
                        colors: const <Color>
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
    byteList[0] = 0x00; // Frame type
    byteList.setAll(1, namespaceId);
    byteList.setAll(11, instanceId);
    return byteList;
  }
}