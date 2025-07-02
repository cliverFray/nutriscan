import 'dart:io';

import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_profile.dart';
import '../services/nutrition_tip_service.dart';
import '../models/nutrition_tip.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';

import '../utils/scheduleMonthlyNotification.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

import 'package:app_settings/app_settings.dart';

import 'package:device_info_plus/device_info_plus.dart'; // para API checks

//final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  final NutritionTipsService _nutritionTipsService = NutritionTipsService();
  UserProfile? _userProfile;
  List<NutritionTip> _nutritionTips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    requestNotificationPermissionIfNeeded();
  }

  void abrirConfiguracionNotificaciones() {
    AppSettings.openAppSettings();
  }

  Future<void> requestNotificationPermissionIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt >= 33) {
        final androidPlugin = flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

        final granted = await androidPlugin?.requestNotificationsPermission();
        if (granted == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("No se concedió permiso para las notificaciones"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 6),
              action: SnackBarAction(
                label: "Ir a configuración",
                textColor: Colors.white,
                onPressed: () {
                  abrirConfiguracionNotificaciones();
                },
              ),
            ),
          );
          // Opcional: mostrar diálogo para guiar al usuario
        } else {
          // Solo mostrar si no se mostró antes
          bool alreadyShown = prefs.getBool('notif_permission_shown') ?? false;
          if (!alreadyShown) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Se concedió permiso para las notificaciones"),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 6),
              ),
            );
            // Guardar que ya se mostró
            await prefs.setBool('notif_permission_shown', true);
          }
        }
      }
    }
  }

  Future<void> _fetchData() async {
    try {
      UserProfile? userProfile = await _userService.getUserProfile();
      List<NutritionTip> nutritionTips =
          await _nutritionTipsService.fetchNutritionTips();
      setState(() {
        _userProfile = userProfile;
        _nutritionTips = nutritionTips;
        _isLoading = false;
      });
    } catch (e) {
      if (e.toString().contains('Token inválido') ||
          e.toString().contains('token expired') ||
          e.toString().contains('401')) {
        // Actualiza el isLoggedIn a false
        await _userService.clearTokens();

        // Redirige al LoginScreen
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        // Otros errores: mostrar como antes
        setState(() {
          _isLoading = false;
        });
        print("Error fetching data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _fetchData, // Aquí llamas a tu método
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _nutritionTips.isEmpty
                ? ListView(
                    // OBLIGATORIO para que funcione el pull-to-refresh
                    children: [
                      Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red, size: 60),
                              SizedBox(height: 10),
                              Text(
                                "No se pudieron cargar los consejos nutricionales.\nPor favor, revisa tu conexión o vuelve a intentarlo.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 20),
                            ]),
                      ),
                    ],
                  )
                : ListView(
                    physics:
                        AlwaysScrollableScrollPhysics(), // Para que siempre se pueda hacer pull-to-refresh
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Bienvenida al usuario
                            Text(
                              'Bienvenido, ${_userProfile?.userFirstName ?? ''}',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Detecta, nutre y crece',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                            SizedBox(height: 20),
                            // Título de consejos prácticos
                            Text(
                              'Consejos prácticos',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 16),
                            _buildNutritionTipsCarousel(),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildNutritionTipsCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 250.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(seconds: 2),
        viewportFraction: 0.8,
      ),
      items: _nutritionTips.map((tip) {
        return Builder(
          builder: (BuildContext context) {
            return Card(
              color: Color(0xFF83B56A).withOpacity(0.9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              child: Container(
                width: double.infinity,
                height: double
                    .infinity, // Asegúrate que ocupe todo el espacio de la tarjeta
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mostrar imagen del tip
                    if (tip.imageUrl.isNotEmpty)
                      Image.network(
                        tip.imageUrl,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    SizedBox(height: 10),
                    Text(
                      tip.title,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          tip.description,
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
