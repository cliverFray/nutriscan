import 'package:dio/dio.dart';

import '../models/nutritional_term.dart';
import '../utils/base_url_back_ns.dart';
import '../utils/dio_client.dart';

class NutritionalTermService {
  final String baseUrl = BaseUrlBackNs.baseUrl; // URL base de la API
  late Dio dioClient;
  NutritionalTermService() {
    dioClient = Dio(BaseOptions(baseUrl: baseUrl));
    dioClient.interceptors.add(AuthInterceptor(dioClient, baseUrl));
  }

  Future<List<NutritionalTerm>> fetchNutritionalTerms() async {
    try {
      // Realiza la solicitud GET al endpoint para obtener términos nutricionales
      final response = await dioClient.get('/nutritional-terms/');

      if (response.statusCode == 200) {
        // Convierte la respuesta JSON en una lista de NutritionalTerm
        final List<dynamic> jsonResponse = response.data;
        return jsonResponse
            .map((data) => NutritionalTerm.fromJson(data))
            .toList();
      } else {
        throw Exception(
            'Failed to load nutritional terms. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al cargar los términos nutricionales: $e');
    }
  }
}
