import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:app_settings/app_settings.dart';

import '../utils/scheduleMonthlyNotification.dart'; // Tu función para agendar la notificación

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
  bool cameraPermission = false;
  bool galleryPermission = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      enableNotifications = prefs.getBool('enableNotifications') ?? true;
      cameraPermission = prefs.getBool('cameraPermission') ?? false;
      galleryPermission = prefs.getBool('galleryPermission') ?? false;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableNotifications', enableNotifications);
    await prefs.setBool('cameraPermission', cameraPermission);
    await prefs.setBool('galleryPermission', galleryPermission);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Color(0xFF83B56A),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<bool> requestNotificationPermissionIfNeeded() async {
    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt >= 33) {
        final androidPlugin = flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        final granted = await androidPlugin?.requestNotificationsPermission();
        return granted ?? false;
      }
    }
    return true; // permisos concedidos automáticamente en Android <13
  }

  Future<void> _onEnableNotificationsChanged(bool value) async {
    bool granted = true;

    if (value) {
      granted = await requestNotificationPermissionIfNeeded();
    }

    setState(() {
      enableNotifications = value && granted;
    });

    await _savePreferences();

    try {
      if (enableNotifications) {
        await scheduleMonthlyReminder(); // Agenda notificación mensual
        _showSnackBar('Notificaciones habilitadas');
      } else {
        await flutterLocalNotificationsPlugin.cancelAll();
        _showSnackBar('Notificaciones deshabilitadas');
      }
    } catch (e) {
      _showSnackBar('Error al actualizar notificaciones', isError: true);
    }

    if (!granted) {
      _showSnackBar('Permiso de notificación no concedido', isError: true);
      AppSettings.openAppSettings();
    }
  }

  void _onCameraPermissionChanged(bool value) async {
    setState(() => cameraPermission = value);
    await _savePreferences();
  }

  void _onGalleryPermissionChanged(bool value) async {
    setState(() => galleryPermission = value);
    await _savePreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones y permisos'),
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
          SwitchListTile(
            title: Text('Habilitar permiso a cámara'),
            value: cameraPermission,
            onChanged: _onCameraPermissionChanged,
          ),
          SwitchListTile(
            title: Text('Habilitar permiso a galería'),
            value: galleryPermission,
            onChanged: _onGalleryPermissionChanged,
          ),
        ],
      ),
    );
  }
}
