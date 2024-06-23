import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'contact_detail_screen.dart';
import 'contacts.screen.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  List<Contact> favoriteContacts = [];
  bool isEditMode = false; // Flag untuk menandakan mode edit

  @override
  void initState() {
    super.initState();
    _getFavoriteContacts();
  }

  Future<void> _getFavoriteContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Contact> allContacts = await ContactsService.getContacts();

    List<Contact> favorites = [];
    allContacts.forEach((contact) {
      bool isFavorite = prefs.getBool(contact.identifier ?? '') ?? false;
      if (isFavorite) {
        favorites.add(contact);
      }
    });

    setState(() {
      favoriteContacts = favorites;
    });
  }

  Future<void> _toggleFavorite(Contact contact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Pastikan identifier tidak null sebelum menyimpan ke SharedPreferences
    String identifier = contact.identifier ?? '';

    bool isFavorite = prefs.getBool(identifier) ?? false;
    prefs.setBool(identifier, !isFavorite);

    _getFavoriteContacts(); // Refresh favorite list
  }

  void _navigateToAddContact() async {
    await Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => ContactsScreen(),
      ),
    )
        .then((value) {
      _getFavoriteContacts(); // Refresh favorite list after returning from ContactsScreen
    });
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
      
    });
  }

  void _deleteFavorite(Contact contact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Pastikan identifier tidak null sebelum digunakan
    String identifier = contact.identifier ?? '';

    prefs.remove(identifier); // Hapus dari favorit

    _getFavoriteContacts(); // Refresh favorite list
  }

  Future<void> _showDeleteConfirmationDialog(Contact contact) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Favorite'),
          content: Text(
              'Are you sure you want to remove this contact from favorites?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _deleteFavorite(contact);
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favourites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: isEditMode
            ? SizedBox() // Jika dalam mode edit, tidak menampilkan leading icon
            : IconButton(
                icon: Icon(Icons.add, color: Colors.blue),
                onPressed: _navigateToAddContact,
              ),
        actions: [
          TextButton(
            onPressed: _toggleEditMode,
            child: Text(isEditMode ? 'Done' : 'Edit',
                style: TextStyle(color: Colors.blue, fontSize: 15)),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: favoriteContacts.length,
        itemBuilder: (context, index) {
          Contact contact = favoriteContacts[index];
          final phoneNumber = contact.phones?.isNotEmpty == true
              ? contact.phones!.first.value ?? ''
              : '';
          final avatar = contact.avatar;

          return Column(
            children: <Widget>[
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
                trailing: isEditMode
                    ? IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteConfirmationDialog(contact),
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.info,
                          color: const Color.fromARGB(255, 15, 102, 173),
                        ),
                        onPressed: () {},
                      ),
                onTap: () async {
                  if (!isEditMode) {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ContactDetailScreen(
                          contact: contact,
                          onDelete: () {
                            _deleteFavorite(contact); // Hapus dari favorit
                          },
                          onFavoriteToggle: () async {
                            await _toggleFavorite(
                                contact); // Toggle status favorit
                            _getFavoriteContacts(); // Refresh favorit list
                          },
                        ),
                      ),
                    );
                    _getFavoriteContacts(); // Refresh favorit list setelah kembali dari ContactDetailScreen
                  } else {
                    _deleteFavorite(
                        contact); // Hapus dari favorit saat dalam mode edit
                  }
                },
              ),
              Divider(), // Tambahkan garis tepi bawah setelah setiap ListTile
            ],
          );
        },
      ),
    );
  }
}
