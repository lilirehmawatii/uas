import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuickResponseScreen extends StatefulWidget {
  @override
  _QuickResponseScreenState createState() => _QuickResponseScreenState();
}

class _QuickResponseScreenState extends State<QuickResponseScreen> {
  List<String> quickResponses = [];

  @override
  void initState() {
    super.initState();
    _loadQuickResponses();
  }

  Future<void> _loadQuickResponses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      quickResponses = prefs.getStringList('quickResponses') ?? [];
    });
  }

  Future<void> _addQuickResponse(String response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      quickResponses.add(response);
      prefs.setStringList('quickResponses', quickResponses);
    });
  }

  Future<void> _deleteQuickResponse(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      quickResponses.removeAt(index);
      prefs.setStringList('quickResponses', quickResponses);
    });
  }

  void _showAddQuickResponseDialog() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Quick Response'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter quick response'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                _addQuickResponse(controller.text);
                Navigator.of(context).pop();
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
        title: Text('Quick Response'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddQuickResponseDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: quickResponses.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(quickResponses[index]),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteQuickResponse(index),
                ),
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
