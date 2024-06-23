import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class BlockNumberScreen extends StatefulWidget {
  @override
  _BlockNumberScreenState createState() => _BlockNumberScreenState();
}

class _BlockNumberScreenState extends State<BlockNumberScreen> {
  List<String> blockedNumbers = [];

  void _showAddOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showAddContactManuallyDialog();
              },
              child: Text('Add Contact Manually', style: TextStyle(color: Colors.blue),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToContactsScreen();
              },
              child: Text('Import from Contacts',style: TextStyle(color: Colors.blue),),
            ),
          ],
        );
      },
    );
  }

  void _showAddContactManuallyDialog() {
    final TextEditingController numberController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Block Call From'),
          content: TextField(
            controller: numberController,
            decoration: InputDecoration(labelText: 'Enter phone number'),
            keyboardType: TextInputType.phone,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  blockedNumbers.add(numberController.text);
                });
                Navigator.of(context).pop();
              },
              child: Text('Block'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToContactsScreen() async {
    if (await Permission.contacts.request().isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactsScreen(
            contacts: contacts,
            onContactSelected: (Contact contact) {
              if (contact.phones != null && contact.phones!.isNotEmpty) {
                setState(() {
                  blockedNumbers.add(contact.phones!.first.value ?? '');
                });
              }
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Block Number',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.blue,),
            onPressed: _showAddOptionsDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: blockedNumbers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(blockedNumbers[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red,),
              onPressed: () {
                setState(() {
                  blockedNumbers.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class ContactsScreen extends StatelessWidget {
  final Iterable<Contact> contacts;
  final Function(Contact) onContactSelected;

  ContactsScreen({required this.contacts, required this.onContactSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Contact'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          Contact contact = contacts.elementAt(index);
          return ListTile(
            title: Text(contact.displayName ?? ''),
            onTap: () {
              onContactSelected(contact);
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}
