import 'package:dio/dio.dart';

import '../utils/base_url_back_ns.dart';
import '../utils/dio_client.dart';
import '../models/nutrition_tip.dart'; // Asegúrate de importar el modelo NutritionTip

class NutritionTipsService {
  final String baseUrl = BaseUrlBackNs.baseUrl; // URL base de la API
  late Dio dioClient;
  NutritionTipsService() {
    dioClient = Dio(BaseOptions(baseUrl: baseUrl));
    dioClient.interceptors.add(AuthInterceptor(dioClient, baseUrl));
  }

  Future<List<NutritionTip>> fetchNutritionTips() async {
    try {
      // Realiza la solicitud GET al endpoint para obtener consejos de nutrición
      final response = await dioClient.get('/nutrition-tips/');

      if (response.statusCode == 200) {
        // Convierte la respuesta JSON en una lista de NutritionTip
        final List<dynamic> jsonResponse = response.data;
        return jsonResponse.map((data) => NutritionTip.fromJson(data)).toList();
      } else {
        throw Exception(
            'Failed to load nutrition tips. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al cargar los consejos de nutrición: $e');
    }
  }
}
