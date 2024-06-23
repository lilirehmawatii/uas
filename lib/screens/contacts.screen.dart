import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'contact_detail_screen.dart';

class ContactsScreen extends StatefulWidget {
  final Function(Contact)? onContactSelected;

  ContactsScreen({this.onContactSelected});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = [];
  List<Contact> _originalContacts = [];

  @override
  void initState() {
    super.initState();
    _getPermissions();
  }

  _getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      _fetchContacts();
    }
  }

  _fetchContacts() async {
    Iterable<Contact> contactsList = await ContactsService.getContacts();
    setState(() {
      contacts = contactsList.toList();
      _originalContacts = List.from(contacts); // Save the original contacts list
    });
  }

  void _filterContacts(String query) {
    if (query.isEmpty) {
      setState(() {
        contacts = List.from(_originalContacts); // Restore original contacts list
      });
    } else {
      setState(() {
        contacts = _originalContacts.where((contact) {
          final displayName = contact.displayName?.toLowerCase() ?? '';
          return displayName.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contacts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.blue,
              size: 30,
            ),
            onPressed: _addContact,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0), // Mengurangi padding dari 8.0 menjadi 4.0
            child: Container(
              width: 385,
              decoration: BoxDecoration(
                color: Colors.grey[200], // Warna latar belakang abu-abu
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), // Padding horizontal
                child: Row(
                  children: [
                    Icon(Icons.search, size: 20),
                    SizedBox(width: 8), // Jarak antara ikon dan teks
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none, // Hilangkan border TextField
                        ),
                        onChanged: (value) {
                          _filterContacts(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                Contact contact = contacts[index];
                final phoneNumber = contact.phones?.isNotEmpty == true
                    ? contact.phones!.first.value ?? ''
                    : '';
                final avatar = contact.avatar;

                return Column(
                  children: [
                    ListTile(
                      title: Text(contact.displayName ?? ''),
                      subtitle: Text(phoneNumber),
                      leading: (avatar != null && avatar.isNotEmpty)
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(avatar),
                            )
                          : CircleAvatar(
                              child: Text(contact.initials()),
                            ),
                      onTap: () async {
                        if (widget.onContactSelected != null) {
                          widget.onContactSelected!(contact);
                          Navigator.pop(context);
                        } else {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ContactDetailScreen(
                                contact: contact,
                                onDelete: () {
                                  _deleteContact(contact);
                                },
                                onFavoriteToggle: () {
                                  _fetchContacts(); // Refresh the contact list after toggling favorite
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    Divider(), // Add a divider between each ListTile
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addContact() async {
    final Contact? newContact = await showDialog<Contact?>(
      context: context,
      builder: (context) {
        return AddContactDialog();
      },
    );

    if (newContact != null &&
        newContact.givenName != null &&
        newContact.phones != null &&
        newContact.phones!.isNotEmpty) {
      await ContactsService.addContact(newContact);
      _fetchContacts(); // Refresh the contact list
    }
  }

  void _deleteContact(Contact contact) async {
    await ContactsService.deleteContact(contact);
    _fetchContacts(); // Refresh the contact list after deletion
  }
}

class AddContactDialog extends StatefulWidget {
  @override
  _AddContactDialogState createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Contact'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: 'Phone'),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final String name = _nameController.text;
            final String phone = _phoneController.text;

            if (name.isNotEmpty && phone.isNotEmpty) {
              final newContact = Contact(
                givenName: name,
                phones: [Item(label: 'mobile', value: phone)],
              );
              Navigator.of(context).pop(newContact);
            } else {
              // Optionally show an error message if needed
              Navigator.of(context).pop(null);
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
