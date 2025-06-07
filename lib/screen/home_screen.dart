import 'package:flutter/material.dart';
import 'package:meetbell/database/database_helper.dart';
import 'package:meetbell/screen/add_edit_reminder.dart';
import 'package:meetbell/screen/reminder_detial.dart';
import 'package:meetbell/services/notification_helper.dart';
import 'package:meetbell/services/permission_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _reminder = [];

  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
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
    } else {
      NotificationHelper.cancelNotification(id);
    }
    _loadReminder();
  }

  Future<void> _deleteReminder(int id) async {
    await DbHepler.deleteReminder(id);
    NotificationHelper.cancelNotification(id);
    _loadReminder();
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
        body: _reminder.isEmpty
            ? Center(
                child: Text(
                  "No Meeting Today",
                  style: TextStyle(fontSize: 18, color: Colors.teal),
                ),
              )
            : ListView.builder(
                itemCount: _reminder.length,
                itemBuilder: (context, index) {
                  final reminder = _reminder[index];
                  return Dismissible(
                    key: Key(reminder['id'].toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.redAccent,
                      padding: EdgeInsets.only(right: 30),
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.delete, color: Colors.white, size: 30),
                    ),
                    confirmDismiss: (direction) async {
                      return await _showDeleteConfirmationDialog(context);
                    },
                    onDismissed: (direction) {
                      _deleteReminder(reminder['id']);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Reminder Deleted")),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 6,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReminderDetialScreen(
                                reminderId: reminder['id'],
                              ),
                            ),
                          );
                        },
                        leading: Icon(Icons.notifications, color: Colors.teal),
                        title: Text(
                          reminder['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text("Category: ${reminder['category']}"),
                        trailing: Switch(
                          value: reminder['isActive'] == 1,
                          activeColor: Colors.teal,
                          inactiveTrackColor: Colors.white,
                          inactiveThumbColor: Colors.black54,
                          onChanged: (value) {
                            _toggleReminder(reminder['id'], value);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEditReminder()),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  // show confirmation dialog before deleting a reminder
  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Delete Reminder"),
          content: Text("Are you sure you want to delete this reminder?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Delete", style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }
}
