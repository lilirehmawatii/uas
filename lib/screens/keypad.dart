import 'package:contacts/screens/contacts.screen.dart';
import 'package:contacts_service/contacts_service.dart';
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
  Map<String, Contact> speedDial = {};  // Store speed dial numbers

void _onButtonPressed(String value) {
  if (speedDial.containsKey(value)) {
    Contact contact = speedDial[value]!;
    _showUpdateDialog(value, contact.phones!.first.value ?? ''); // Pass the phone number associated with the speed dial
  } else {
    _showSetDialog(value);
  }
}

  void _showSetDialog(String value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Speed Dial'),
          content: Text('Do you want to set this number for speed dial?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactsScreen(
                      onContactSelected: (Contact contact) {
                        setState(() {
                          speedDial[value] = contact;
                        });
                      },
                    ),
                  ),
                );
              },
              child: Text('Set'),
            ),
          ],
        );
      },
    );
  }

void _showUpdateDialog(String value, String setNumber) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Update Speed Dial'),
        content: Text('This number is already set for $setNumber. Do you want to update it?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Edit'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // Example: Directly call the number
              bool? res = await FlutterPhoneDirectCaller.callNumber(setNumber);
              if (res != null && res == false) {
                print('Could not place call to $setNumber');
              }
            },
            child: Text('Call'),
          ),
        ],
      );
    },
  );
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Click on number to add speed dial',
            style: TextStyle(fontSize: 16, color: Colors.blue),
            textAlign: TextAlign.center,
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'After setting speed dial, Long Click on number to use speed dial in dialer keypad screen.',
            style: TextStyle(fontSize: 14, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
