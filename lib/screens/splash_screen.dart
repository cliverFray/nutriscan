import 'package:flutter/material.dart';
import 'dart:async'; // Necesario para el temporizador

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Simular un tiempo de carga antes de redirigir a la pantalla principal
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacementNamed('/login'); // Reemplaza con tu ruta de destino
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF83B56A), // Color de fondo
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen de logo o bienvenida
              Image.asset('assets/images/logo_nutriscan.png',
                  width: 300, height: 300),
            ],
          ),
        ),
      ),
    );
  }
}
