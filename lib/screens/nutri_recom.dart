// screens/nutritional_terms_screen.dart

import 'package:flutter/material.dart';
import '../models/nutritional_term.dart';
import '../services/nutritional_term_service.dart';
import '../widgets/custom_elevated_button_2.dart';
import 'support_screen.dart';

class NutritionalRecommendationsScreen extends StatefulWidget {
  final bool showAppBar;

  const NutritionalRecommendationsScreen({this.showAppBar = false, Key? key})
      : super(key: key);
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

  Future<void> _refreshTerms() async {
    setState(() {
      _termsFuture = _service.fetchNutritionalTerms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text('Recomendaciones Nutricionales'),
              backgroundColor: Color(0xFF83B56A),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              child: RefreshIndicator(
                onRefresh: _refreshTerms,
                child: FutureBuilder<List<NutritionalTerm>>(
                  future: _termsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView(
                        // Necesitas una lista aunque sea para el RefreshIndicator
                        children: [
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return ListView(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red, size: 60),
                                SizedBox(height: 10),
                                Text(
                                  "Hubo un error al mostrar la información nutricional. Por favor, intente nuevamente más tarde o deslice la pantalla para volver a cargar",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                CustomButton2(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SupportScreen()),
                                    );
                                  },
                                  buttonText: "Ir a soporte",
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return ListView(
                        children: [
                          Center(
                            child: Text(
                                "No hay términos nutricionales disponibles."),
                          ),
                        ],
                      );
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
