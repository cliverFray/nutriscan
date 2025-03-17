import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

//importaciones de firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:intl/date_symbol_data_local.dart'; // Importación necesaria

import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/bottom_nav_menu.dart';
import 'screens/login_screen.dart'; // Para las localizaciones

void main() async {
  //la funcion tiene que ser async
  //con esto nos aseguramos que todo esto se ejecute
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
      'es', null); // Inicializa el formato para español

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //isloggin?
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriScan',
      // Localizaciones soportadas
      supportedLocales: [
        const Locale('en', 'US'), // Inglés
        const Locale('es', 'PE'), // Español de Perú
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primaryColor: Color(0xFF83B56A), // Color principal (verde)
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF83B56A), // Color base para todo el esquema
          primary: Color(0xFF83B56A), // Color primario
          secondary: Color(0xFFFF6F61), // Color secundario (puedes cambiarlo)
        ),
        scaffoldBackgroundColor: Colors.white, // Fondo de todas las pantallas
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF83B56A), // Color de la barra de app
          foregroundColor: Colors.white, // Color del texto en la AppBar
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF83B56A), // Botones en verde
            foregroundColor: Colors.white, // Texto en blanco
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor:
                Color(0xFFFF6F61), // Color de los textos de botones
          ),
        ),
      ),
      home: isLoggedIn ? BottomNavMenu() : LoginScreen(), // Pantalla inicial
    );
  }
}
