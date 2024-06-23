import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Keypad extends StatefulWidget {
  @override
  _KeypadState createState() => _KeypadState();
}

class _KeypadState extends State<Keypad> {
  final List<Map<String, String>> buttons = [
    {'number': '1', 'letters': ''},
    {'number': '2', 'letters': 'ABC'},
    {'number': '3', 'letters': 'DEF'},
    {'number': '4', 'letters': 'GHI'},
    {'number': '5', 'letters': 'JKL'},
    {'number': '6', 'letters': 'MNO'},
    {'number': '7', 'letters': 'PQRS'},
    {'number': '8', 'letters': 'TUV'},
    {'number': '9', 'letters': 'WXYZ'},
    {'number': '*', 'letters': ''},
    {'number': '0', 'letters': '+'},
    {'number': '#', 'letters': ''},
  ];
  String input = '';

  void _onButtonPressed(String value) {
    setState(() {
      input += value;
    });
  }

  void _onCallPressed() async {
    if (input.isNotEmpty) {
      bool? res = await FlutterPhoneDirectCaller.callNumber(input);
      if (res != null && res == false) {
        print('Could not place call to $input');
      }
    }
  }

  void _onDeletePressed() {
    setState(() {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            input,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: 300,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
            ),
            shrinkWrap: true,
            itemCount: buttons.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () {
                    _onButtonPressed(buttons[index]['number']!);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        buttons[index]['number']!,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        buttons[index]['letters']!,
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(), // Spacer to keep the icons aligned properly
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green, // Warna latar belakang hijau
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      12.0), // Padding untuk jarak dari tepi lingkaran
                  child: IconButton(
                    onPressed: _onCallPressed,
                    icon: Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 32,
                    ), // Icon call berwarna putih
                  ),
                ),
              ),
              SizedBox(width: 10), // Jarak antara dua tombol
              IconButton(
                onPressed: _onDeletePressed,
                icon: Icon(Icons.backspace,
                    size: 32), // Ikon backspace tanpa latar belakang
              ),
              Expanded(
                child: Container(), // Spacer to keep the icons aligned properly
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
