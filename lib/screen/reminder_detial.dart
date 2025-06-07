import 'package:flutter/material.dart';
import 'package:meetbell/database/database_helper.dart';

class ReminderDetialScreen extends StatefulWidget {
  final int reminderId;
  const ReminderDetialScreen({super.key, required this.reminderId});

  @override
  State<ReminderDetialScreen> createState() => _ReminderDetialScreenState();
}

class _ReminderDetialScreenState extends State<ReminderDetialScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: DbHepler.getRemindersById(widget.reminderId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.teal)),
          );
        }
        final reminder = snapshot.data!;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.teal),
            backgroundColor: Colors.white,
            title: Text(
              "Reminder Detial",
              style: TextStyle(color: Colors.teal),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),
        );
      },
    );
  }
}
