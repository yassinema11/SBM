import 'package:flutter/material.dart';

class Settings extends StatefulWidget 
{
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
            resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF080a16),

      appBar: AppBar
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
        backgroundColor: const Color(0xFF080a16),
        centerTitle: true,
      ),
      body: Container(), // Add your settings UI here
    );
  }
}
