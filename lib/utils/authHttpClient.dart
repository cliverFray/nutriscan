import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'base_url_back_ns.dart';

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner;
  final String baseUrl = BaseUrlBackNs.baseUrl; // URL base de la API

  AuthHttpClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    // Añade el token de acceso en cada solicitud
    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }

    // Realiza la solicitud y captura la respuesta
    final response = await _inner.send(request);

    // Si la respuesta es 401 (no autorizado), intenta refrescar el token
    if (response.statusCode == 401) {
      final success = await _refreshToken();
      if (success) {
        // Si el token se refrescó exitosamente, reintenta la solicitud original
        accessToken = prefs.getString('access_token');
        request.headers['Authorization'] = 'Bearer $accessToken';
        return _inner.send(request);
      }
    }

    return response;
  }

  // Función para refrescar el token de acceso
  Future<bool> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');

    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await prefs.setString('access_token', data['access']);
        return true;
      }
    }

    return false;
  }
}
