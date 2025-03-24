import 'package:dio/dio.dart';

import '../utils/base_url_back_ns.dart';
import '../utils/dio_client.dart';
import '../models/app_info.dart'; // Asegúrate de importar el modelo AppInfo
import '../models/feedback.dart';

class StaticInfoService {
  final String baseUrl = BaseUrlBackNs.baseUrl; // URL base de la API
  late Dio dioClient;

  StaticInfoService() {
    dioClient = Dio(BaseOptions(baseUrl: baseUrl));
    dioClient.interceptors.add(AuthInterceptor(dioClient, baseUrl));
  }

  Future<AppInfo> fetchAppInfo() async {
    try {
      // Realiza la solicitud GET al endpoint para obtener la información de la aplicación
      final response = await dioClient.get('/app-info/');

      if (response.statusCode == 200) {
        // Convierte la respuesta JSON en una instancia de AppInfo
        return AppInfo.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load app info. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al cargar la información de la aplicación: $e');
    }
  }

  Future<List<Feedback>> fetchFeedbacks() async {
    try {
      final response = await dioClient.get('/feedback/');
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = response.data;
        return jsonResponse.map((data) => Feedback.fromJson(data)).toList();
      } else {
        throw Exception(
            'Error al obtener la retroalimentación. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener la retroalimentación: $e');
    }
  }

  Future<void> sendFeedback(String message) async {
    try {
      await dioClient.post('/feedback/', data: {'message': message});
    } catch (e) {
      throw Exception('Error al enviar la retroalimentación: $e');
    }
  }

  Future<String> fetchPrivacyPolicy() async {
    try {
      final response = await dioClient.get('/privacy-policy/');
      if (response.statusCode == 200) {
        return response.data['content'];
      } else {
        throw Exception('Error al obtener la política de privacidad.');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<String> fetchTermsAndConditions() async {
    try {
      final response = await dioClient.get('/terms-and-conditions/');
      if (response.statusCode == 200) {
        return response.data['content'];
      } else {
        throw Exception('Error al obtener los términos y condiciones.');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
