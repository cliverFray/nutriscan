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
        setState(() {
          _image = File(pickedFile.path);
        });
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

  // Método para seleccionar una foto desde la galería
  // Método para solicitar permisos antes de acceder a la galería
  Future<void> _pickFromGallery() async {
    PermissionStatus galleryStatus;

    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted ||
          await Permission.photos.request().isGranted) {
        // Ya tenemos permiso
        galleryStatus = PermissionStatus.granted;
      } else {
        galleryStatus = await Permission.photos.request();
      }
    } else {
      galleryStatus = await Permission.photos.request();
    }

    if (galleryStatus.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        _validateAndCheckImage(_image!);
      }
    } else if (galleryStatus.isPermanentlyDenied) {
      _showPermissionDialog(
        title: 'Permiso de galería requerido',
        message:
            'Para seleccionar imágenes, debes habilitar el permiso de galería en los ajustes de la aplicación.',
      );
    } else {
      _showSnackBar('Permiso de galería denegado.', isError: true);
    }
  }

  // Método para validar la imagen usando el servicio
  Future<void> _validateAndCheckImage(File image) async {
    final validationResult = await _imageValidationService.validateImage(image);

    if (!validationResult['valid']) {
      // Si la imagen no es válida, muestra el mensaje de error
      _showSnackBar(validationResult['message'], isError: true);
      setState(() {
        _image =
            null; // Reinicia la imagen para que el usuario vuelva a intentar
      });
    } else {
      // Si la imagen es válida, permite continuar
      _showSnackBar('Imagen válida. Puedes continuar.', isError: false);
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
  Future<void> _showLoadingDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Procesando..."),
              ],
            ),
          ),
        );
      },
    );
  }

  // Método para subir la imagen al endpoint de detección
  Future<void> _uploadImage(File image) async {
    // Mostrar indicador de carga
    _showLoadingDialog();
    // Llama al servicio de detección con el ID del niño y la imagen validada
    try {
      final detectionResult = await _detectionService.uploadDetectionImage(
          childId: widget.childId, image: image);

      // Cierra el indicador de carga
      Navigator.pop(context);

      if (detectionResult != null) {
        // Si la detección fue exitosa, navega a la pantalla de resultados
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
        // Si la subida falla, muestra un mensaje de error
        _showSnackBar('Error al subir la imagen para detección.',
            isError: true);
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
                    final validationResult =
                        await _imageValidationService.validateImage(_image!);

                    if (validationResult['valid']) {
                      // Si la imagen es válida, procede a subirla
                      await _uploadImage(_image!);
                    } else {
                      _showSnackBar(
                        validationResult['message'],
                        isError: true,
                      );
                      setState(() {
                        _image = null; // Reinicia la imagen si no es válida
                      });
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
