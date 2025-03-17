import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final String baseUrl;

  AuthInterceptor(this.dio, this.baseUrl);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? accessToken = await getAccessToken(); // Obtener token almacenado
    if (accessToken != null) {
      options.headers["Authorization"] = "Bearer $accessToken";
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expirado, intenta renovarlo
      bool refreshed = await refreshAccessToken();
      if (refreshed) {
        // Reintentar la solicitud original con el nuevo token
        RequestOptions requestOptions = err.requestOptions;
        requestOptions.headers["Authorization"] =
            "Bearer ${await getAccessToken()}";
        return handler.resolve(await dio.fetch(requestOptions));
      }
    }
    handler.next(err);
  }

  Future<bool> refreshAccessToken() async {
    try {
      final dio = Dio();
      String? refreshToken =
          await getRefreshToken(); // Obtener refresh token almacenado
      if (refreshToken == null) return false;

      final response = await dio.post(
        '$baseUrl/token/refresh/',
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        await saveAccessToken(response.data['access']); // Guardar nuevo token
        return true;
      }
    } catch (e) {
      print("Error refrescando token: $e");
    }
    return false;
  }

  /// Función para obtener el token de acceso almacenado
  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  /// Función para obtener el refresh token almacenado
  Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  /// Función para guardar el token de acceso
  Future<void> saveAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }
}
