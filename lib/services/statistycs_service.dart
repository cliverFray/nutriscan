import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/detection_cat_chart.dart';
import '../models/growth_chart.dart';
import '../utils/base_url_back_ns.dart';
import '../utils/dio_client.dart';
import '../models/feedback.dart';

class StaticstycService {
  final String baseUrl = BaseUrlBackNs.baseUrl; // URL base de la API
  late Dio dioClient;

  StaticstycService() {
    dioClient = Dio(BaseOptions(baseUrl: baseUrl));
    dioClient.interceptors.add(AuthInterceptor(dioClient, baseUrl));
  }

  // Gráfico de crecimiento
  Future<GrowthChartData> fetchGrowthChartData(int child_id) async {
    try {
      final response = await dioClient.get('/children/$child_id/growth-chart/');

      if (response.statusCode == 200) {
        print("pesos y tallassss ${GrowthChartData.fromJson(response.data)}");
        return GrowthChartData.fromJson(response.data);
      } else if (response.statusCode == 204) {
        // Devuelve datos vacíos en lugar de lanzar excepción
        return GrowthChartData(
            weights: [], heights: [], dates: [], childName: '');
      } else {
        throw Exception(
            'Error ${response.statusCode}: ${response.data['error'] ?? 'No se pudo obtener los datos.'}');
      }
    } on DioException catch (dioError) {
      final errorMsg = dioError.response?.data['error'] ??
          dioError.message ??
          'Error desconocido al obtener datos de crecimiento';
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception('Error al obtener datos de crecimiento: $e');
    }
  }

  // Gráfico de detección por categorías
  Future<List<DetectionResult>> fetchDetectionCategoryChart(
      int child_id) async {
    try {
      final response =
          await dioClient.get('/children/$child_id/detection-chart/');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        print("Lista deteccionesssssssssss: $jsonList");

        return jsonList.map((json) => DetectionResult.fromJson(json)).toList();
      } else if (response.statusCode == 204) {
        // Devuelve lista vacía
        return [];
      } else {
        throw Exception(
            'Error ${response.statusCode}: ${response.data['error'] ?? 'No se pudo obtener los datos.'}');
      }
    } on DioException catch (dioError) {
      final errorMsg = dioError.response?.data['error'] ??
          dioError.message ??
          'Error desconocido al obtener datos de detección';
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception('Error al obtener datos de detección: $e');
    }
  }
}
