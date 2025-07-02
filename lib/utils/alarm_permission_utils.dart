import 'package:flutter/services.dart';

Future<bool> canScheduleExactAlarms() async {
  const platform = MethodChannel('alarm_permission_channel');
  try {
    final bool canSchedule =
        await platform.invokeMethod('canScheduleExactAlarms');
    return canSchedule;
  } catch (e) {
    print('Error al verificar permiso: $e');
    return false; // En caso de error, asumimos que no está activo
  }
}
