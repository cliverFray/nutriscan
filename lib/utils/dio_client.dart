import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Para base64, utf8 y json

class DioClient {
  final Dio dio;

  DioClient(String baseUrl) : dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        String? accessToken = prefs.getString('access_token');

        if (accessToken == null) {
          return handler.reject(DioError(
            requestOptions: options,
            error: 'No access token available',
          ));
        }

        // Decodificar y comprobar expiración del token
        final payload = _decodeJwtPayload(accessToken);
        final expiryDate =
            DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);

        if (DateTime.now().isAfter(expiryDate)) {
          // Refrescar token
          final refreshToken = prefs.getString('refresh_token');
          if (refreshToken == null) {
            return handler.reject(DioError(
              requestOptions: options,
              error: 'No refresh token available',
            ));
          }

          final response = await dio.post('/token/refresh/',
              data: {'refresh': refreshToken},
              options: Options(headers: {'Content-Type': 'application/json'}));

          if (response.statusCode == 200) {
            final accessToken = response.data['access'] as String?;
            if (accessToken != null) {
              await prefs.setString('access_token', accessToken);
            } else {
              return handler.reject(DioError(
                requestOptions: options,
                error: 'Failed to refresh token: No access token in response',
              ));
            }
          } else {
            return handler.reject(DioError(
              requestOptions: options,
              error: 'Failed to refresh token',
            ));
          }
        }

        // Agregar token al encabezado
        options.headers['Authorization'] = 'Bearer $accessToken';
        handler.next(options);
      },
    ));
  }

  Map<String, dynamic> _decodeJwtPayload(String token) {
    final parts = token.split('.');
    final payload = base64Url.normalize(parts[1]);
    return json.decode(utf8.decode(base64Url.decode(payload)));
  }
}
