import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactDetailScreen extends StatefulWidget {
  final Contact contact;
  final Function onDelete;
  final Function onFavoriteToggle;
   

  ContactDetailScreen({
    required this.contact,
    required this.onDelete,
    required this.onFavoriteToggle,
  
  });

  @override
  _ContactDetailScreenState createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.contact.identifier ?? '') ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
      prefs.setBool(widget.contact.identifier ?? '', isFavorite);
      widget.onFavoriteToggle(); // Panggil fungsi onFavoriteToggle
    });
  }

  void _sendSMS(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunch(smsUri.toString())) {
      await launch(smsUri.toString());
    } else {
      throw 'Could not launch $smsUri';
    }
  }

  Future<void> _makeCall(String phoneNumber) async {
    if (phoneNumber.isNotEmpty) {
      bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
      if (res != null && !res) {
        print('Could not place call to $phoneNumber');
      }
    }
  }

  void _sendEmail(String emailAddress) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: emailAddress);
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  void _editContact(BuildContext context) async {
    final Uri editContactUri = Uri(
      scheme: 'content',
      path: 'contacts/people/${widget.contact.identifier}',
    );
    if (await canLaunchUrl(editContactUri)) {
      await launchUrl(editContactUri);
    } else {
      throw 'Could not launch $editContactUri';
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Contact'),
          content: Text('Are you sure you want to delete this contact?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog sebelum menghapus kontak
                _deleteContact(context); // Panggil fungsi hapus kontak
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteContact(BuildContext context) async {
    try {
      await ContactsService.deleteContact(widget.contact);
      widget.onDelete(); // Panggil onDelete setelah kontak dihapus
      Navigator.of(context).pop(); // Kembali ke layar sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete contact')),
      );
    }
  }

  void _shareContact() {
    final String contactDetails = 'Name: ${widget.contact.displayName}\n'
        'Phone: ${widget.contact.phones?.isNotEmpty == true ? widget.contact.phones!.first.value : ''}\n'
        'Email: ${widget.contact.emails?.isNotEmpty == true ? widget.contact.emails!.first.value : ''}';
    Share.share(contactDetails);
  }

  @override
  Widget build(BuildContext context) {
    final phoneNumber = widget.contact.phones?.isNotEmpty == true
        ? widget.contact.phones!.first.value ?? ''
        : '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Contact',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: () => _editContact(context),
            child: Text(
              'Edit',
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            (widget.contact.avatar != null && widget.contact.avatar!.isNotEmpty)
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: MemoryImage(widget.contact.avatar!),
                  )
                : CircleAvatar(
                    radius: 50,
                    child: Text(
                      widget.contact.initials(),
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
            SizedBox(height: 16),
            Text(
              widget.contact.displayName ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue, // Warna latar belakang
                        shape: BoxShape.circle, // Bentuk lingkaran
                      ),
                      child: IconButton(
                        icon: Icon(Icons.message),
                        color: Colors.white, // Warna ikon
                        onPressed: () => _sendSMS(phoneNumber),
                      ),
                    ),
                    Text('Message', style: TextStyle(color: Colors.blue)),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue, // Warna latar belakang
                        shape: BoxShape.circle, // Bentuk lingkaran
                      ),
                      child: IconButton(
                        icon: Icon(Icons.call),
                        color: Colors.white,
                        onPressed: () => _makeCall(phoneNumber),
                      ),
                    ),
                    Text('Call', style: TextStyle(color: Colors.blue)),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue, // Warna latar belakang
                        shape: BoxShape.circle, // Bentuk lingkaran
                      ),
                      child: IconButton(
                        icon: Icon(Icons.videocam),
                        color: Colors.white,
                        onPressed: () {
                          final Uri whatsappUri = Uri(
                            scheme: 'https',
                            host: 'wa.me',
                            path: phoneNumber,
                          );
                          launchUrl(whatsappUri);
                        },
                      ),
                    ),
                    Text('Video', style: TextStyle(color: Colors.blue)),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue, // Warna latar belakang
                        shape: BoxShape.circle, // Bentuk lingkaran
                      ),
                      child: IconButton(
                        icon: Icon(Icons.email),
                        color: Colors.white,
                        onPressed: () {
                          final email =
                              widget.contact.emails?.isNotEmpty == true
                                  ? widget.contact.emails!.first.value ?? ''
                                  : '';
                          _sendEmail(email);
                        },
                      ),
                    ),
                    Text('Email', style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.blue),
              title: Text('Mobile'),
              subtitle: Text(phoneNumber, style: TextStyle(color: Colors.blue)),
            ),
            ListTile(
              leading: Icon(Icons.share, color: Colors.blue,),
              title: Text('Share Contact'),
              onTap: _shareContact,
            ),
            ListTile(
              leading: Icon(isFavorite ? Icons.star : Icons.star_border, color: Color.fromARGB(255, 221, 199, 4)),
              title: Text(isFavorite ? 'Remove from favorites' : 'Add to favorites'),
              onTap: _toggleFavorite,
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.blue),
              title: Text('Delete Contact', style: TextStyle(color: Colors.blue)),
              onTap: () {
                _confirmDelete(context); // Panggil konfirmasi hapus kontak
              },
            ),
            ListTile(
              leading: Icon(Icons.block, color: Colors.red),
              title: Text('Block this Caller', style: TextStyle(color: Colors.red)),
              onTap: () {
                // Implement block caller functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
