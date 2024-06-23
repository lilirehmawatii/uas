import 'package:app_settings/app_settings.dart';
import 'package:contacts/screens/call_theme_screen.dart';
import 'package:contacts/screens/language_screen.dart';
import 'package:contacts/screens/select_sim_card.dart';
import 'package:contacts/screens/speed_dial_screen.dart';
import 'package:contacts/screens/theme_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'block_number_screen.dart';
import 'most_contacted_screen.dart';
import 'quick_response_screen.dart';
import 'flash_on_call_screen.dart';


class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String _selectedSim = 'Always Ask';

  @override
  void initState() {
    super.initState();
    _loadSelectedSim();
  }

  Future<void> _loadSelectedSim() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedSim = prefs.getString('selectedSim') ?? 'Always Ask';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          _buildListTile(
            context,
            icon: Icons.account_circle,
            title: 'Most Contacted Contacts',
            backgroundColor: Color.fromARGB(255, 17, 17, 17),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MostContactedScreen(),
                ),
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.message,
            title: 'Quick Response',
            backgroundColor: const Color.fromARGB(255, 3, 100, 180),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuickResponseScreen(),
                ),
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.palette,
            title: 'Call Theme',
            backgroundColor: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CallThemeScreen(),
                ),
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.block,
            title: 'Block Number',
            backgroundColor: Colors.red,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlockNumberScreen(),
                ),
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            backgroundColor: Colors.grey,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThemeScreen(),
                ),
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.flashlight_on_sharp,
            title: 'Flash On Call',
            backgroundColor: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashOnCallScreen(),
                ),
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.speed,
            title: 'Speed Dial',
            backgroundColor: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SpeedDialScreen(),
                ),
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.language,
            title: 'Change Language',
            backgroundColor: const Color.fromARGB(255, 231, 210, 21),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LanguageScreen(),
                ),
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.music_note,
            title: 'Change Ringtone',
            backgroundColor: const Color.fromARGB(255, 213, 71, 238),
            onTap: ()  {
                AppSettings.openAppSettings(type: AppSettingsType.sound);
            },
          ),
          _buildListTile(
            context,
            icon: Icons.sim_card,
            title: 'Select SimCard: $_selectedSim',
            backgroundColor: Colors.purple,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectSimScreen(),
                ),
              );
              _loadSelectedSim(); // Reload the selected SIM after coming back
            },
          ),
          _buildListTile(
            context,
            icon: Icons.share,
            title: 'Share App',
            backgroundColor: Colors.pink,
            onTap: () {
              Share.share(
                'Please try this application\n\nhttps://play.google.com/store/apps/details?id=icontacts.ios.dialer.icall',
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.lock,
            title: 'Privacy Policy',
            backgroundColor: const Color.fromARGB(255, 5, 88, 156),
            onTap: () async {
              const url = 'https://sites.google.com/view/superb-llc-apps/home';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'There are many settings like changing theme and ringtones, blocker, flash-on-call, and quick response for incoming and outgoing call screen.',
              style: TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required Color backgroundColor,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 25,
        ),
      ),
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
