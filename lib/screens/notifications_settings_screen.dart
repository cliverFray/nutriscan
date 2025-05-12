import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../utils/scheduleMonthlyNotification.dart'; // Tu función existente

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationsSettingsScreen extends StatefulWidget {
  @override
  _NotificationsSettingsScreenState createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool enableNotifications = true;
  bool dailyTips = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      enableNotifications = prefs.getBool('enableNotifications') ?? true;
      dailyTips = prefs.getBool('dailyTips') ?? false;
    });

    if (enableNotifications) {
      scheduleMonthlyNotification(context);
    }
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableNotifications', enableNotifications);
    await prefs.setBool('dailyTips', dailyTips);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Color(0xFF83B56A),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _onEnableNotificationsChanged(bool value) async {
    setState(() {
      enableNotifications = value;
      if (!value) {
        dailyTips = false;
      }
    });
    await _savePreferences();

    try {
      if (enableNotifications) {
        await scheduleMonthlyNotification(context);
        _showSnackBar('Notificaciones habilitadas');
      } else {
        await flutterLocalNotificationsPlugin.cancelAll();
        _showSnackBar('Notificaciones deshabilitadas');
      }
    } catch (e) {
      _showSnackBar('Error al actualizar notificaciones', isError: true);
    }
  }

  Future<void> _onDailyTipsChanged(bool value) async {
    setState(() {
      dailyTips = value;
    });
    await _savePreferences();

    // Aquí solo guardamos, aún no programamos tips diarios (opcional después)
    _showSnackBar(
        dailyTips ? 'Tips diarios habilitados' : 'Tips diarios deshabilitados',
        isError: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
        backgroundColor: Color(0xFF83B56A),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text('Habilitar Notificaciones'),
            value: enableNotifications,
            onChanged: _onEnableNotificationsChanged,
          ),
          if (enableNotifications)
            SwitchListTile(
              title: Text('Recibir Tips Diarios'),
              value: dailyTips,
              onChanged: _onDailyTipsChanged,
            ),
        ],
      ),
    );
  }
}
