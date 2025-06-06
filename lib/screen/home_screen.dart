import 'package:flutter/material.dart';
import 'package:meetbell/database/database_helper.dart';
import 'package:meetbell/services/notification_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _reminder = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadReminder();
  }

  Future<void> _loadReminder() async {
    final reminders = await DbHepler.getReminder();
    setState(() {
      _reminder = reminders;
    });
  }

  Future<void> _toggleReminder(int id, bool isActive) async {
    await DbHepler.toggleReminder(id, isActive);
    if (isActive) {
      final reminder = _reminder.firstWhere((rem) => rem['id'] == id);
      NotificationHelper.scheduleNotification(
        id,
        reminder['title'],
        reminder['category'],
        DateTime.parse(reminder['reminderTime']),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Meet Bell", style: TextStyle(color: Colors.teal)),
          iconTheme: IconThemeData(color: Colors.teal),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
