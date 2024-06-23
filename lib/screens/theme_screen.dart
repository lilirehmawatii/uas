import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeScreen extends StatefulWidget {
  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('theme_mode');
    setState(() {
      _themeMode = _getThemeModeFromString(themeModeString ?? 'system');
    });
  }

  void _updateThemeMode(ThemeMode themeMode) async {
    setState(() {
      _themeMode = themeMode;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme_mode', _getStringFromThemeMode(themeMode));
  }

  ThemeMode _getThemeModeFromString(String themeModeString) {
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _getStringFromThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Light Theme'),
            trailing: _themeMode == ThemeMode.light ? Icon(Icons.check) : null,
            onTap: () {
              _updateThemeMode(ThemeMode.light);
            },
          ),
          ListTile(
            title: Text('Dark Theme'),
            trailing: _themeMode == ThemeMode.dark ? Icon(Icons.check) : null,
            onTap: () {
              _updateThemeMode(ThemeMode.dark);
            },
          ),
          ListTile(
            title: Text('Default System'),
            trailing: _themeMode == ThemeMode.system ? Icon(Icons.check) : null,
            onTap: () {
              _updateThemeMode(ThemeMode.system);
            },
          ),
        ],
      ),
    );
  }
}
