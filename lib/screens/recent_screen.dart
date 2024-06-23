import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:permission_handler/permission_handler.dart';

class RecentScreen extends StatefulWidget {
  @override
  _RecentScreenState createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<CallLogEntry> allLogs = [];
  List<CallLogEntry> missedLogs = [];
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkPermissionsAndLoadCallLogs();
  }

  Future<void> _checkPermissionsAndLoadCallLogs() async {
    var status = await Permission.phone.status;
    if (status.isGranted) {
      _loadCallLogs();
    } else {
      var result = await Permission.phone.request();
      if (result.isGranted) {
        _loadCallLogs();
      } else {
        print('Permission not granted');
      }
    }
  }

  void _loadCallLogs() async {
    Iterable<CallLogEntry> logs = await CallLog.get();
    setState(() {
      allLogs = logs.toList();
      missedLogs =
          allLogs.where((log) => log.callType == CallType.missed).toList();
    });
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _deleteLog(CallLogEntry log) {
    _showDeleteConfirmationDialog(log);
  }

  void _showDeleteConfirmationDialog(CallLogEntry log) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Log'),
          content: Text('Are you sure you want to delete this log?'),
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
                setState(() {
                  allLogs.remove(log);
                  missedLogs =
                      allLogs.where((log) => log.callType == CallType.missed).toList();
                });
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recent',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Missed'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _toggleEditing,
            child: Text(isEditing ? 'Done' : 'Edit',
                style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCallLogList(allLogs),
          _buildCallLogList(missedLogs),
        ],
      ),
    );
  }

  Widget _buildCallLogList(List<CallLogEntry> logs) {
    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        CallLogEntry log = logs[index];
        return Column(
          children: [
            ListTile(
              leading: Icon(Icons.call),
              title: Text(log.formattedNumber ?? 'Unknown'),
              subtitle: Text(log.name ?? ''),
              trailing: isEditing
                  ? IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteLog(log),
                    )
                  : Text(
                      log.callType == CallType.incoming ? 'Incoming' : 'Outgoing'),
            ),
            Divider(), // Add a divider between each ListTile
          ],
        );
      },
    );
  }
}
