import 'dart:io';
import 'package:dio/dio.dart';
import '../utils/compressImage.dart';
import '../utils/base_url_back_ns.dart';
import '../utils/dio_client.dart';

class ImageValidationService {
  final String baseUrl = BaseUrlBackNs.baseUrl; // URL base de la API
  late Dio dioClient;
  ImageValidationService() {
    dioClient = Dio(BaseOptions(baseUrl: baseUrl));
    dioClient.interceptors.add(AuthInterceptor(dioClient, baseUrl));
  }
  final CompressImage _compressImage = CompressImage();

  Future<Map<String, dynamic>> validateImage(File image, int child_id) async {
    try {
      // Obtiene la extensión de la imagen
      final extension = image.path.split('.').last.toLowerCase();

      File fileToUpload;

      if (extension == 'heic') {
        // ⚠️ NO intentes comprimir si es HEIC
        fileToUpload = image;
      } else {
        // Comprime la imagen si NO es HEIC
        final compressed =
            await _compressImage.compressImage(image, maxWidth: 800);
        fileToUpload = compressed;
      }

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(fileToUpload.path),
      });

      // Realiza la solicitud POST al endpoint para validar la imagen
      final response = await dioClient.post(
        '/validate-image/$child_id/',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        // Procesa la respuesta si es exitosa
        return response.data as Map<String, dynamic>;
      } else {
        // Maneja errores de respuesta
        return {
          'valid': false,
          'message':
              'Error al validar la imagen. Código de estado: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      print("Errorrrrrrrrrrrrrrrrrrrrr ${e.response?.data}");
      if (e.response != null && e.response?.data != null) {
        return {
          "valid": false,
          "message": _parseValidateImageError(e.response?.data)
        };
      }
      return {
        "error": true,
        "message": 'Error de conexión: conectate a internet'
      };
    } catch (e) {
      // Maneja errores de conexión u otros
      return {
        'valid': false,
        'message':
            'Error desconocido intentalo nuevamente o contacte con el soporte tecnico en la seccion de perfil'
      };
    }
  }

  String _parseValidateImageError(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) return data['message'];
      if (data.containsKey('user_errors')) {
        return data['user_errors'].values.first[0];
      }
    }
    return 'Error desconocido al validar la imagen.';
  }
}
