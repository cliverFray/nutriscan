import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_profile.dart';
import '../services/nutrition_tip_service.dart';
import '../models/nutrition_tip.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';

import '../utils/scheduleMonthlyNotification.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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
    // Programar recordatorio mensual después de renderizado
    // Esperar a que el widget esté completamente montado antes de usar context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        requestNotificationPermissions(); // <-- AÑADE ESTO
        scheduleMonthlyNotification(context);
      }
    });
  }

  Future<void> requestNotificationPermissions() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final androidPlugin =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestPermission();
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
      setState(() {
        _isLoading = false;
      });
      print("Error fetching data: $e");
    }
  }

  Future<void> showTestNotification(BuildContext context) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'monthly_reminder',
        'Recordatorio mensual',
        channelDescription: 'Te recuerda actualizar los datos de tu hijo',
        importance: Importance.max,
        priority: Priority.high,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        1, // ID diferente al programado
        'Prueba de notificación',
        'Esto es una notificación de prueba.',
        notificationDetails,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('No se pudo mostrar la notificación de prueba. $e'),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _nutritionTips.isEmpty
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 60),
                      SizedBox(height: 10),
                      Text(
                        "No se pudieron cargar los consejos nutricionales.\nPor favor, revisa tu conexión o vuelve a intentarlo.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                    ]))
              : Padding(
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
                        style: TextStyle(fontSize: 16, color: Colors.black54),
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
                      // Cards rotativos de consejos prácticos
                      _buildNutritionTipsCarousel(),
                      SizedBox(height: 16),

                      /* ElevatedButton(
                        onPressed: () => showTestNotification(context),
                        child: Text('Probar notificación inmediata'),
                      ) */
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
