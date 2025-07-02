import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:device_info_plus/device_info_plus.dart'; // para API checks
import 'dart:io';

import 'package:app_settings/app_settings.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  // configuración de zona horaria
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Lima'));

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  final initSettings = InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

Future<void> scheduleMonthlyReminder() async {
  final now = tz.TZDateTime.now(tz.local);
  final lastDay = DateTime(now.year, now.month + 1, 0);
  final scheduled = tz.TZDateTime(
      tz.local, lastDay.year, lastDay.month, lastDay.day, 10, 0, 0);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Recordatorio mensual',
    'Por favor actualiza el peso y talla del niño',
    scheduled,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'monthly_reminder',
        'Recordatorio mensual',
        channelDescription: 'Actualización de datos mensuales',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
  );
}
