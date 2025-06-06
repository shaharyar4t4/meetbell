import 'package:flutter/material.dart';

class AddEditReminder extends StatefulWidget {
  final int? reminderId;
  const AddEditReminder({super.key, this.reminderId});

  @override
  State<AddEditReminder> createState() => _AddEditReminderState();
}

class _AddEditReminderState extends State<AddEditReminder> {
  final _fromKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
