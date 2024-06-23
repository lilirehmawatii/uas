import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlashOnCallScreen extends StatefulWidget {
  @override
  _FlashOnCallScreenState createState() => _FlashOnCallScreenState();
}

class _FlashOnCallScreenState extends State<FlashOnCallScreen> {
  bool isFlashOnCallEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadFlashOnCallSetting();
  }

  Future<void> _loadFlashOnCallSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFlashOnCallEnabled = prefs.getBool('flashOnCall') ?? false;
    });
  }

  Future<void> _toggleFlashOnCall(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFlashOnCallEnabled = value;
      prefs.setBool('flashOnCall', isFlashOnCallEnabled);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flash On Call'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Enable Flash On Call'),
              value: isFlashOnCallEnabled,
              onChanged: _toggleFlashOnCall,
            ),
            SizedBox(height: 16),
            Text(
              'When enabled, the flash will blink during incoming calls. This can be useful in noisy environments or for those who are hearing impaired.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
