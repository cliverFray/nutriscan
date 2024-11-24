import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
        backgroundColor: Color(0xFF83B56A),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Habilitar Notificaciones'),
            value: enableNotifications,
            onChanged: (value) {
              setState(() {
                enableNotifications = value;
              });
            },
          ),
          if (enableNotifications)
            SwitchListTile(
              title: Text('Recibir Tips Diarios'),
              value: dailyTips,
              onChanged: (value) {
                setState(() {
                  dailyTips = value;
                });
              },
            ),
        ],
      ),
    );
  }
}
