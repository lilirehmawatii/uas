import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';

class MostContactedScreen extends StatefulWidget {
  @override
  _MostContactedScreenState createState() => _MostContactedScreenState();
}

class _MostContactedScreenState extends State<MostContactedScreen> {
  Map<String, int> contactFrequency = {};

  @override
  void initState() {
    super.initState();
    _fetchCallLogs();
  }

  Future<void> _fetchCallLogs() async {
    Iterable<CallLogEntry> callLogs = await CallLog.get();

    Map<String, int> frequency = {};
    for (var entry in callLogs) {
      if (entry.name != null && entry.name!.isNotEmpty) {
        frequency[entry.name!] = (frequency[entry.name!] ?? 0) + 1;
      } else if (entry.number != null && entry.number!.isNotEmpty) {
        frequency[entry.number!] = (frequency[entry.number!] ?? 0) + 1;
      }
    }

    setState(() {
      contactFrequency = frequency;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, int>> sortedContacts = contactFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: Text('Most Contacted Contacts'),
      ),
      body: ListView.builder(
        itemCount: sortedContacts.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(sortedContacts[index].key),
                subtitle: Text('Contacted ${sortedContacts[index].value} times'),
              ),
              Divider(), // Add Divider here
            ],
          );
        },
      ),
    );
  }
}
