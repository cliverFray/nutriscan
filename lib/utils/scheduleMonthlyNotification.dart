import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> scheduleMonthlyNotification(BuildContext context) async {
  try {
    final now = tz.TZDateTime.now(tz.local);
    final lastDay = DateTime(now.year, now.month + 1, 0).day;

    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      lastDay,
      10,
    );

    const androidDetails = AndroidNotificationDetails(
      'monthly_reminder',
      'Recordatorio mensual',
      channelDescription: 'Te recuerda actualizar los datos de tu hijo',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Actualización mensual',
      'Es fin de mes. Recuerda actualizar la información de tu hijo.',
      scheduledDate,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('No se pudo programar el recordatorio mensual. $e'),
        actions: [
          TextButton(
            child: Text('Cerrar'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
