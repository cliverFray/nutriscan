import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_profile.dart';
import '../services/nutrition_tip_service.dart';
import '../models/nutrition_tip.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      utf8.decode(tip.title.runes.toList()),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      utf8.decode(tip.description.runes.toList()),
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
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
