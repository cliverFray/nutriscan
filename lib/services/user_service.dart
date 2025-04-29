import 'package:dio/dio.dart';

import '../models/user_update.dart';
import '../models/users.dart';
import '../models/user_profile.dart';
import '../utils/base_url_back_ns.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/dio_client.dart';

class UserService {
  final String baseUrl = BaseUrlBackNs.baseUrl; // URL base de la API
  late Dio dioClient;
  UserService() {
    dioClient = Dio(BaseOptions(baseUrl: baseUrl));
    dioClient.interceptors.add(AuthInterceptor(dioClient, baseUrl));
  }

  // Método para registrar un usuario
  // Método para registrar un usuario
  Future<String?> registerUser(User user) async {
    try {
      final response = await dioClient.post(
        '/register/',
        data: {
          'user': {
            'username': user.userPhone,
            'first_name': user.userFirstName,
            'last_name': user.userLastName,
            'email': user.userEmail,
            'password': user.userPassword,
            'date_joined': user.userRegistrationDate.toIso8601String(),
          },
          'userDNI': user.userDNI,
          'userPhone': user.userPhone,
          'userPlace': user.userPlace,
        },
      );

      if (response.statusCode == 201) {
        return null; // Registro exitoso
      } else {
        final errorResponse = response.data;
        return _parseBackendError(errorResponse);
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return _parseBackendError(e.response?.data);
      }
      return 'Error de conexión: ${e.message}';
    } catch (e) {
      return 'Error inesperado: $e';
    }
  }

  String _parseBackendError(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('userDNI')) {
        return data['userDNI'][0];
      }
      if (data.containsKey('userPhone')) {
        return data['userPhone'][0];
      }
      if (data.containsKey('username')) {
        return data['username'][0];
      }
      if (data.containsKey('non_field_errors')) {
        return data['non_field_errors'][0];
      }
    }
    return 'Error desconocido';
  }

  // Método para iniciar sesión y guardar tokens
  Future<String?> loginUser(String phone, String password) async {
    try {
      final response = await dioClient.post(
        '/login/',
        data: {
          'userPhone': phone,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data.containsKey('access') && data.containsKey('refresh')) {
          await _saveTokens(data['access'], data['refresh']);
        } else {
          throw Exception('Respuesta del servidor sin tokens válidos.');
        }
        return null; // Inicio de sesión exitoso
      } else {
        return 'Failed to login: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error de conexión: $e';
    }
  }

  // Método privado para guardar tokens en SharedPreferences
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('refresh_token', refreshToken);
      await prefs.setBool('isLoggedIn', true);
    } catch (e) {
      throw Exception("Error al guardar los tokens: $e");
    }
  }

  // Método para obtener el token de acceso
  /*Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }*/

  // Método para obtener el perfil del usuario autenticado
  Future<UserProfile?> getUserProfile() async {
    try {
      final response = await dioClient
          .get('/user/profile/'); // Solo pasas el endpoint relativo

      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception(
            'Error al obtener el perfil. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para obtener los datos actuales del usuario logueado
  Future<UserUpdate?> getUserProfileForUpdate() async {
    try {
      // Realiza la solicitud GET al endpoint relativo
      final response = await dioClient.get('/user/update-info/');

      // Verifica el código de estado
      if (response.statusCode == 200) {
        final data = response.data; // Datos de la respuesta
        print('Datos del perfil para actualización: $data');

        return UserUpdate.fromJson(data); // Convertir a objeto UserUpdate
      } else {
        throw Exception(
            'Error al obtener los datos del perfil. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      // Manejo de errores generales
      throw Exception(
          'Error al obtener los datos del perfil para actualización: $e');
    }
  }

  // Método para actualizar los datos del usuario logueado
  Future<String?> updateUserProfile(UserUpdate user) async {
    try {
      final response = await dioClient.put(
        '/user/update/',
        data: {
          'user': {
            'username': user.userPhone, // Si es necesario
            'first_name': user.userFirstName,
            'last_name': user.userLastName,
            'email': user.userEmail,
            'password': user.userPassword?.isNotEmpty == true
                ? user.userPassword
                : null,
          },
          'additional_info': {
            'userDNI': user.userDNI,
            'userPhone': user.userPhone,
            'userPlace': user.userPlace,
          }
        },
      );

      if (response.statusCode == 200) {
        return null; // Éxito
      } else {
        return _parseUpdateError(response.data);
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return _parseUpdateError(e.response?.data);
      }
      return 'Error de conexión: ${e.message}';
    } catch (e) {
      return 'Error inesperado: $e';
    }
  }

  String _parseUpdateError(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('email')) return data['email'];
      if (data.containsKey('userDNI')) return data['userDNI'];
      if (data.containsKey('error')) return data['error'];
      if (data.containsKey('user_errors')) {
        return data['user_errors'].values.first[0];
      }
      if (data.containsKey('additional_info_errors')) {
        return data['additional_info_errors'].values.first[0];
      }
    }
    return 'Error desconocido al actualizar el perfil.';
  }

  ///----para el cambio de contraseña
  // Método para solicitar el código de restablecimiento de contraseña
  Future<String?> requestPasswordResetCode(String phone, String email) async {
    try {
      final response = await dioClient.post(
        '/password-reset/request/',
        data: {'phone': phone, 'email': email},
      );

      if (response.statusCode == 200) {
        return null; // Solicitud exitosa
      } else {
        return response.data['error'] ?? 'Error desconocido';
      }
    } catch (e) {
      return 'Error de conexión: $e';
    }
  }

  // Método para verificar el código de restablecimiento de contraseña
  Future<String?> verifyPasswordResetCode(String phone, String code) async {
    try {
      final response = await dioClient.post(
        '/password-reset/verify/',
        data: {'phone': phone, 'code': code},
      );

      if (response.statusCode == 200) {
        return null; // Código verificado con éxito
      } else {
        return response.data['error'] ?? 'Error desconocido';
      }
    } catch (e) {
      return 'Error de conexión: $e';
    }
  }

  // Método para reenviar el código de restablecimiento de contraseña
  Future<String?> resendPasswordResetCode(String phone, String email) async {
    try {
      final response = await dioClient.post(
        '/password-reset/resend/',
        data: {'phone': phone, 'email': email},
      );

      if (response.statusCode == 200) {
        return null; // Código reenviado con éxito
      } else {
        throw Exception('Error al reenviar el código: ${response.statusCode}');
      }
    } catch (e) {
      return 'Error de conexión: $e';
    }
  }

  // Método para cambiar la contraseña después de verificar el código
  Future<String?> resetPassword(
      String phone, String code, String newPassword) async {
    try {
      final response = await dioClient.post(
        '/password-reset/reset/',
        data: {
          'phone': phone,
          'code': code,
          'new_password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        return null; // Contraseña cambiada exitosamente
      } else {
        throw Exception(
            'Error al restablecer la contraseña: ${response.statusCode}');
      }
    } catch (e) {
      return 'Error de conexión: $e';
    }
  }

  ///--------Metodos para la verificacion de identidad----------------
  // Método para enviar el código de verificación de identidad
  Future<String?> sendVerificationCode(
      String phone, String dni, String email) async {
    try {
      final response = await dioClient.post(
        '/verification/generate-send-code/',
        data: {'phone': phone, 'dni': dni, 'email': email},
        options: Options(
          extra: {'requiresAuth': false}, // <<< bandera personalizada
        ),
      );

      final responseBody = response.data;

      if (response.statusCode == 200 && responseBody['codigo'] == 'exito') {
        return null; // Éxito
      } else {
        // Manejo de respuestas conocidas desde el backend
        final codigo = responseBody['codigo'];
        final mensaje = responseBody['mensaje'];

        switch (codigo) {
          case 'telefono_requerido':
            return 'Por favor, ingresa un número de teléfono.';
          case 'telefono_invalido':
            return 'El número de teléfono debe tener 9 dígitos.';
          case 'telefono_registrado': // Nuevo caso para teléfono ya registrado
            return 'El número de teléfono ya está registrado.';
          case 'dni_registrado': // Nuevo caso para DNI ya registrado
            return 'El DNI ya está registrado.';
          case 'correo_registrado': // Nuevo caso para DNI ya registrado
            return 'El correo ya está registrado.';
          case 'error_envio_sms':
            return 'Hubo un problema al enviar el SMS. Intenta nuevamente.';
          case 'error_envio_correo':
            return 'Hubo un problema al enviar el código por correo. Intenta nuevamente.';
          default:
            return mensaje ?? 'Ocurrió un error desconocido.';
        }
      }
    } on DioException catch (e) {
      // Manejo específico de errores de Dio
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return 'La conexión tardó demasiado. Verifica tu internet.';
      } else if (e.type == DioExceptionType.badResponse) {
        // El servidor respondió con un status 400, 401, 500, etc.
        final data = e.response?.data;
        return data?['mensaje'] ?? 'Error inesperado del servidor.';
      } else if (e.type == DioExceptionType.connectionError) {
        return 'No se pudo establecer conexión. Verifica tu internet.';
      } else {
        return 'Error inesperado: ${e.message}';
      }
    } catch (e) {
      // Otro tipo de error inesperado
      return 'Error desconocido: ${e.toString()}';
    }
  }

  // Método para verificar el código de identidad
  Future<String?> verifyIdentityCode(String phone, String code) async {
    try {
      final response = await dioClient.post(
        '/verification/verify-code/',
        data: {'phone': phone, 'code': code},
      );

      if (response.statusCode == 200) {
        return null; // Código verificado con éxito
      } else {
        final errorResponse = response.data;
        return errorResponse['error'] ?? 'Error desconocido';
      }
    } catch (e) {
      return 'Error de conexión: $e';
    }
  }

  // Método para reenviar el código de verificación de identidad
  Future<String?> resendIdentityVerificationCode(
      String phone, String email) async {
    try {
      final response = await dioClient.post(
        '/verification/resend-code/',
        data: {'phone': phone, 'email': email},
      );

      if (response.statusCode == 200) {
        return null; // Código reenviado con éxito
      } else {
        final errorResponse = response.data;
        final codigo = errorResponse['codigo'];

        switch (codigo) {
          case 'telefono_requerido':
            return 'Por favor, ingresa un número de teléfono.';
          case 'telefono_no_encontrado':
            return 'El número de teléfono no está registrado. Por favor, regístralo primero.';
          case 'error_envio_sms':
            return 'Hubo un problema al enviar el código por SMS. Intenta nuevamente.';
          case 'error_envio_correo':
            return 'Hubo un problema al enviar el código por correo. Intenta nuevamente.';
          default:
            return errorResponse['mensaje'] ?? 'Error desconocido';
        }
      }
    } catch (e) {
      return 'Error de conexión: $e';
    }
  }

  // Método para obtener lista de hijos
  Future<List> fetchChildren() async {
    try {
      final response = await dioClient.get('/children/');

      if (response.statusCode == 200) {
        return response.data as List; // Devuelve la lista de hijos
      } else {
        throw Exception(
            'Failed to load children. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener lista de hijos: $e');
      return [];
    }
  }

  Future<String?> logoutUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');

      if (refreshToken == null) {
        return 'No se encontró el refresh token.';
      }

      final response = await dioClient.post(
        '/user/logout/',
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 205) {
        // Limpiar los tokens del dispositivo
        await prefs.remove('access_token');
        await prefs.remove('refresh_token');
        await prefs.setBool('isLoggedIn', false);
        return null; // Logout exitoso
      } else {
        return 'Error al cerrar sesión. Código: ${response.statusCode}';
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return e.response?.data['error'] ??
            'Error desconocido al cerrar sesión.';
      }
      return 'Error de conexión: ${e.message}';
    } catch (e) {
      return 'Error inesperado: $e';
    }
  }

  Future<String?> deleteAccount(String password) async {
    try {
      final response = await dioClient.delete(
        '/account/delete/',
        data: {'password': password}, // El cuerpo se envía en el campo `data`
      );

      if (response.statusCode == 204) {
        return null; // Cuenta eliminada exitosamente
      } else {
        return 'Error en la eliminación de cuenta. Código de estado: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error de conexión: $e';
    }
  }
}
