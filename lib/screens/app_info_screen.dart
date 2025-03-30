import 'package:flutter/material.dart';
import '../services/static_info.dart';
import '../models/app_info.dart';

class AppInfoScreen extends StatefulWidget {
  @override
  _AppInfoScreenState createState() => _AppInfoScreenState();
}

class _AppInfoScreenState extends State<AppInfoScreen> {
  final StaticInfoService _infoService = StaticInfoService();
  AppInfo? _appInfo;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAppInfo();
  }

  Future<void> _fetchAppInfo() async {
    try {
      final appInfo = await _infoService.fetchAppInfo();
      setState(() {
        _appInfo = appInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar la información de la aplicación.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información de la Aplicación'),
        backgroundColor: Color(0xFF83B56A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nombre de la Aplicación: ${_appInfo!.appName}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Versión: ${_appInfo!.appVersion}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Desarrollador: ${_appInfo!.developer}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        _appInfo!.description,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
      ),
    );
  }
}
