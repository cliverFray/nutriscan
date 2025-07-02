import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/validate_image.dart'; // Importa el servicio de validación
import '../services/detection_service.dart'; // Importa el servicio de detección
import 'result_detection_screen.dart';
import '../widgets/custom_button_icon.dart';
import '../widgets/custom_elevated_button_2.dart';
import '../models/malnutrition_detection.dart';

import 'package:permission_handler/permission_handler.dart'; // import para los permisos

import 'package:device_info_plus/device_info_plus.dart';

class TakeOrPickPhotoScreen extends StatefulWidget {
  final int childId;

  const TakeOrPickPhotoScreen({Key? key, required this.childId})
      : super(key: key);

  // Método para recibir datos usando `arguments`
  static TakeOrPickPhotoScreen fromArguments(Map<String, dynamic> args) {
    return TakeOrPickPhotoScreen(
      childId: args['childId'] as int,
    );
  }

  @override
  _TakeOrPickPhotoScreenState createState() => _TakeOrPickPhotoScreenState();
}

class _TakeOrPickPhotoScreenState extends State<TakeOrPickPhotoScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final ImageValidationService _imageValidationService =
      ImageValidationService(); // Instancia del servicio de validación
  final DetectionService _detectionService =
      DetectionService(); // Instancia del servicio de detección

  bool imageIsValid = false;

  void _showPermissionDialog({required String title, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: Text('Abrir ajustes'),
          ),
        ],
      ),
    );
  }

  // Método para tomar una foto con la cámara
  // Método para solicitar permisos antes de tomar la foto
  Future<void> _takePhoto() async {
    final cameraStatus = await Permission.camera.request();

    if (cameraStatus.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _showLoadingDialog("Mostrando la imagen....");
        setState(() {
          _image = File(pickedFile.path);
        });
        Navigator.pop(context);
        _validateAndCheckImage(_image!);
      }
    } else if (cameraStatus.isPermanentlyDenied) {
      _showPermissionDialog(
        title: 'Permiso de cámara requerido',
        message:
            'Para tomar fotos, debes habilitar el permiso de cámara en los ajustes de la aplicación.',
      );
    } else {
      _showSnackBar('Permiso de cámara denegado.', isError: true);
    }
  }

  // Método para seleccionar una foto desde la galería (solo Android)
  Future<void> _pickFromGallery() async {
    // En Android 13+ usamos READ_MEDIA_IMAGES; en versiones anteriores READ_EXTERNAL_STORAGE
    final isAndroid13OrAbove =
        Platform.isAndroid && (await _getAndroidSdkInt()) >= 33;
    final galleryPermission =
        isAndroid13OrAbove ? Permission.photos : Permission.storage;

    final status = await galleryPermission.status;

    if (status.isGranted) {
      // Permiso concedido
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        _validateAndCheckImage(_image!);
      }
    } else if (status.isDenied) {
      // Solicitar permiso
      final newStatus = await galleryPermission.request();
      if (newStatus.isGranted) {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
          _validateAndCheckImage(_image!);
        }
      } else if (newStatus.isPermanentlyDenied) {
        _showPermissionDialog(
          title: 'Permiso de galería requerido',
          message:
              'Para seleccionar imágenes, debes habilitar el permiso de galería en los ajustes de la aplicación.',
        );
      } else {
        _showSnackBar('Permiso de galería denegado.', isError: true);
      }
    } else if (status.isPermanentlyDenied) {
      _showPermissionDialog(
        title: 'Permiso de galería requerido',
        message:
            'Para seleccionar imágenes, debes habilitar el permiso de galería en los ajustes de la aplicación.',
      );
    } else {
      _showSnackBar('Permiso de galería denegado.', isError: true);
    }
  }

// Método para obtener la versión de SDK de Android
  Future<int> _getAndroidSdkInt() async {
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.version.sdkInt ?? 0;
    } catch (e) {
      print('Error obteniendo SDK: $e');
      return 0;
    }
  }

  // Método para validar la imagen usando el servicio
  Future<bool> _validateAndCheckImage(File image) async {
    // Mostrar el loader
    _showLoadingDialog("Validando la imagen. Esto no tomará mucho tiempo....");

    final validationResult =
        await _imageValidationService.validateImage(image, widget.childId);

    // Cerrar el loader
    Navigator.pop(context);

    if (!validationResult['valid']) {
      // Imagen no válida
      _showSnackBar(validationResult['message'], isError: true);
      setState(() {
        _image = null; // Reinicia la imagen
      });
      imageIsValid = false;
      return false;
    } else {
      if (validationResult['error'] ?? false) {
        // Imagen no válida
        _showSnackBar(validationResult['message'], isError: true);
        imageIsValid = false;
        return false;
      }
      // Imagen válida
      _showSnackBar('Imagen válida. Puedes continuar.', isError: false);
      imageIsValid = true;
      return true;
    }
  }

  // Método para mostrar mensajes flotantes
  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Método para mostrar el indicador de carga
  Future<void> _showLoadingDialog(String message) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Método para subir la imagen al endpoint de detección
  Future<void> _uploadImage(File image) async {
    // Mostrar indicador de carga
    _showLoadingDialog("Subiendo y procesando......");
    // Llama al servicio de detección con el ID del niño y la imagen validada
    try {
      final detectionResult = await _detectionService.uploadDetectionImage(
          childId: widget.childId, image: image);

      // Cierra el indicador de carga
      Navigator.pop(context);

      if (detectionResult is Map<String, dynamic> &&
          detectionResult!.containsKey('detectionResult') &&
          detectionResult!.containsKey('immediateRecommendation') &&
          detectionResult!.containsKey('imc') &&
          detectionResult!.containsKey('imcCategory')) {
        /* final String resultado = detectionResult['detectionResult']!;
        final String recomendacion = detectionResult['immediateRecommendation']!;
        final double imc = double.tryParse(detectionResult['imc'].toString()) ?? 0.0;
        final String imcCategory = detectionResult['imcCategory']!; */

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultDetectionScreen(
              imagenAnalizada: image,
              detectionData: detectionResult,
            ),
          ),
        );
      } else {
        // Si contiene la llave 'error'
        if (detectionResult is Map<String, dynamic> &&
            detectionResult!.containsKey('error')) {
          final errorMessage = detectionResult['error']!;
          // Si la subida falla, muestra un mensaje de error
          _showSnackBar(errorMessage, isError: true);
        }
        if (detectionResult is Map<String, dynamic> &&
            detectionResult!.containsKey('unknowerror')) {
          final errorMessage = detectionResult['unknowerror']!;
          // Si la subida falla, muestra un mensaje de error
          _showSnackBar(errorMessage, isError: true);
        }

        if (detectionResult is Map<String, dynamic> &&
            detectionResult!.containsKey('conexionerror')) {
          final errorMessage = detectionResult['conexionerror']!;
          // Si la subida falla, muestra un mensaje de error
          _showSnackBar(errorMessage, isError: true);
        }
      }
    } catch (e) {
      // Cierra el indicador de carga en caso de error
      Navigator.pop(context);
      _showSnackBar('Error al procesar la imagen: $e', isError: true);
    }
  }

  // Método para cancelar el proceso
  void _cancelProcess() {
    Navigator.pop(context); // Regresa a la pantalla anterior sin tomar acción
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tomar o subir foto'),
        backgroundColor: Color(0xFF83B56A),
        foregroundColor: Color(0xFFFFFFFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Detecta la desnutrición',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),

            // Mostrar imagen seleccionada o tomada
            _image != null
                ? Image.file(
                    _image!,
                    height: 250,
                  )
                : Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Aquí se mostrará la imagen tomada o seleccionada',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
            SizedBox(height: 16),

            // Botón para tomar una foto
            Center(
              child: IconButtonWithText(
                onPressed: _takePhoto,
                icon: Icon(Icons.camera),
                labelText: 'Tomar foto',
              ),
            ),

            SizedBox(height: 16),

            // Botón para seleccionar una foto desde la galería
            Center(
              child: IconButtonWithText(
                onPressed: _pickFromGallery,
                icon: Icon(Icons.photo),
                labelText: 'Seleccionar desde galería',
              ),
            ),
            SizedBox(height: 16),

            // Botón para confirmar la imagen seleccionada o tomada
            if (_image != null)
              Center(
                child: CustomButton2(
                  onPressed: () async {
                    // Validar y subir la imagen si cumple con los requisitos
                    //final isValid = await _validateAndCheckImage(_image!);
                    if (imageIsValid) {
                      await _uploadImage(_image!);
                    }
                  },
                  buttonText: "Validar y Subir Foto",
                ),
              ),

            // Botón para cancelar el proceso
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _cancelProcess,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                child: Text('Cancelar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
