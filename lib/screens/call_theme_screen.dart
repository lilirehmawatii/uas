import 'package:flutter/material.dart';

class CallThemeScreen extends StatefulWidget {
  const CallThemeScreen({super.key});

  @override
  State<CallThemeScreen> createState() => _CallThemeScreenState();
}

class _CallThemeScreenState extends State<CallThemeScreen> {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme'),
      ),
      body: Center(
        child: Text('Not Found'),
      ),
    );
  }
}