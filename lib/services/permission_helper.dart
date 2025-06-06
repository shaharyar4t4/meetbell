import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermissions() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}
