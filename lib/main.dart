import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

//importaciones de firebase

import 'package:intl/date_symbol_data_local.dart'; // Importación necesaria

import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/bottom_nav_menu.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart'; // Para las localizaciones

//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'utils/scheduleMonthlyNotification.dart';

/* Future<void> _createNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'monthly_reminder', // id
    'Recordatorio mensual', // name
    description: 'Te recuerda actualizar los datos de tu hijo',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
} */

void main() async {
  //la funcion tiene que ser async
  //con esto nos aseguramos que todo esto se ejecute
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
      'es', null); // Inicializa el formato para español

  // Inicializa las notificaciones locales
  /* const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  ); */

  //await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  //await _createNotificationChannel();

  WidgetsFlutterBinding.ensureInitialized();

  await initNotifications(); // Inicializa el plugin y zona horaria

  tz.initializeTimeZones();
  tz.setLocalLocation(
      tz.getLocation('America/Lima')); // Ajusta si estás en otra zona

  //isloggin?
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  bool onboardingComplete = prefs.getBool('onboardingComplete') ?? false;

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    showOnboarding: !onboardingComplete,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool showOnboarding;
  const MyApp({
    Key? key,
    required this.isLoggedIn,
    required this.showOnboarding,
  }) : super(key: key);

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
      home: showOnboarding
          ? OnboardingScreen()
          : isLoggedIn
              ? BottomNavMenu()
              : LoginScreen(), // Pantalla inicial
    );

    // Programa la notificación si es fin de mes
  }
}
