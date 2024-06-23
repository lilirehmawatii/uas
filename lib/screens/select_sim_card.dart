import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectSimScreen extends StatefulWidget {
  @override
  _SelectSimScreenState createState() => _SelectSimScreenState();
}

class _SelectSimScreenState extends State<SelectSimScreen> {
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

  Future<void> _selectSim(String sim) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedSim = sim;
      prefs.setString('selectedSim', sim);
    });
  }

  Widget _buildSimOption(String title, String value) {
    return ListTile(
      title: Text(title),
      trailing: _selectedSim == value ? Icon(Icons.check, color: Colors.blue) : null,
      onTap: () {
        _selectSim(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select SIM Card',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSimOption('Always Ask', 'Always Ask'),
            _buildSimOption('SIM 1', 'SIM 1'),
            _buildSimOption('SIM 2', 'SIM 2'),
            SizedBox(height: 20),
            Text(
              'The latest development in Android smartphones offers a dual SIM feature to users. You can use the services of two different telcos on the same smartphone without any external hassle. With the help of the dual SIM feature, users get the option to select a specific telecom provider for messages and calls',
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
