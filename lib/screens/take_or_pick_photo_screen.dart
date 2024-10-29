import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutriscan/models/users.dart';
import 'package:nutriscan/services/upload_image_service.dart';
import 'package:nutriscan/services/user_service.dart';

import '../widgets/custom_button_icon.dart';
import '../widgets/custom_elevated_button_2.dart';
import 'result_detection_screen.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class TakeOrPickPhotoScreen extends StatefulWidget {
  @override
  _TakeOrPickPhotoScreenState createState() => _TakeOrPickPhotoScreenState();
}

class _TakeOrPickPhotoScreenState extends State<TakeOrPickPhotoScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Método para tomar una foto con la cámara
  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _validateImage(_image!);
    }
  }

  // Método para seleccionar una foto desde la galería
  Future<void> _pickFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _validateImage(_image!);
    }
  }

  // Simulación de validación de imagen
  void _validateImage(File image) {
    // Simulación de validaciones: En este ejemplo verificamos solo el tamaño del archivo
    final imageSize = image.lengthSync();
    final maxImageSize = 5 * 1024 * 1024; // 5MB como tamaño máximo

    if (imageSize > maxImageSize) {
      _showSnackBar(
        'La imagen es muy grande. Selecciona una más pequeña.',
        isError: true,
      );
    } else {
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
                    // Esperar a que se obtenga el usuario actual de manera asíncrona
                    User? user = await UserService().getCurrentUser();

                    if (user != null) {
                      // Subir la imagen si se obtuvo el usuario
                      final uploaded = await uploadImageAsPng2(_image!, user);

                      if (uploaded.isNotEmpty) {
                        _showSnackBar(
                          'Foto subida correctamente. Ahora puedes continuar.',
                          isError: false,
                        );
                        // Navegación a la pantalla de resultados con la URL de la imagen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultDetectionScreen(
                                imagenAnalizadaUrl: uploaded,
                                diagnostico: "Sano",
                                recomendacionInmediata:
                                    "El niño está saludable. Continúe con los buenos hábitos alimenticios.",
                                esSaludable: true),
                          ),
                        );
                      } else {
                        _showSnackBar('Error al subir la foto.', isError: true);
                      }
                    } else {
                      _showSnackBar('Error al obtener usuario.', isError: true);
                    }
                  },
                  buttonText: "Subir foto",
                ),
              )
          ],
        ),
      ),
    );
  }
}
