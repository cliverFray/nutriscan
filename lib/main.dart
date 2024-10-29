import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

//importaciones de firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:intl/date_symbol_data_local.dart'; // Importación necesaria

import 'package:flutter_localizations/flutter_localizations.dart'; // Para las localizaciones

void main() async {
  //la funcion tiene que ser async
  //con esto nos aseguramos que todo esto se ejecute
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
      'es', null); // Inicializa el formato para español

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      initialRoute: AppRoutes.signin,
      routes: AppRoutes.routes,
    );
  }
}
