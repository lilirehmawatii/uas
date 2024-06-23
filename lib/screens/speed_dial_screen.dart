import 'package:flutter/material.dart';
import 'keypad.dart';

class SpeedDialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speed Dial'),
      ),
      body: Keypad(),
    );
  }
}
