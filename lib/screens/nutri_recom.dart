// screens/nutritional_terms_screen.dart

import 'package:flutter/material.dart';
import '../models/nutritional_term.dart';
import '../services/nutritional_term_service.dart';
import 'dart:convert';

class NutritionalRecommendationsScreen extends StatefulWidget {
  @override
  _NutritionalTermsScreenState createState() => _NutritionalTermsScreenState();
}

class _NutritionalTermsScreenState
    extends State<NutritionalRecommendationsScreen> {
  final NutritionalTermService _service = NutritionalTermService();
  late Future<List<NutritionalTerm>> _termsFuture;

  @override
  void initState() {
    super.initState();
    _termsFuture = _service.fetchNutritionalTerms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Texto que aparece antes del FutureBuilder
            Text(
              "Aprende sobre los nutrientes esenciales",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<NutritionalTerm>>(
                future: _termsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child:
                            Text("No hay términos nutricionales disponibles."));
                  } else {
                    return ListView(
                      padding: EdgeInsets.all(8),
                      children: snapshot.data!
                          .map((term) => _buildNutritionalCard(term))
                          .toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionalCard(NutritionalTerm term) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(term.imageUrl,
                height: 80, width: 80, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text(
              term.name,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF83B56A)),
            ),
            SizedBox(height: 8),
            Text(
              term.description,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 8),
            Text(
              "Ejemplos: ${term.examples}",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
