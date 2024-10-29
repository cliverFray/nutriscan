import 'package:flutter/material.dart';

import 'recipes_screen.dart';

class NutritionalRecommendationsScreen extends StatelessWidget {
  final String childName;
  final String nutritionalStatus;
  final List<String> personalizedRecommendations;
  final List<String> generalTips;
  final List<String> healthyRecipes;

  NutritionalRecommendationsScreen({
    required this.childName,
    required this.nutritionalStatus,
    required this.personalizedRecommendations,
    required this.generalTips,
    required this.healthyRecipes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recomendaciones Nutricionales'),
        backgroundColor: Color(0xFF83B56A), // Color principal de la app
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Subtítulo con el estado del niño
            Text(
              'Estado Nutricional de $childName: $nutritionalStatus',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            // Recomendaciones Personalizadas
            Text(
              'Recomendaciones Personalizadas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...personalizedRecommendations
                .map((rec) => _buildRecommendationCard(rec))
                .toList(),

            SizedBox(height: 32),

            // Sección de Sugerencias Generales
            Text(
              'Sugerencias Generales de Alimentación',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...generalTips.map((tip) => _buildTipCard(tip)).toList(),

            SizedBox(height: 32),

            // Botones de Acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Acción para ver más detalles
                  },
                  child: Text('Ver más detalles'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Acción para ver recetas
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecipeScreen()),
                    );
                  },
                  child: Text('Ver recetas'),
                ),
              ],
            ),

            SizedBox(height: 32),

            // Recetas Saludables
            Text(
              'Recetas Saludables',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...healthyRecipes
                .map((recipe) => _buildRecipeCard(recipe))
                .toList(),
          ],
        ),
      ),
    );
  }

  // Método para construir una card de recomendación personalizada
  Widget _buildRecommendationCard(String recommendation) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 40),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                recommendation,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir una card de sugerencias generales
  Widget _buildTipCard(String tip) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.lightbulb, color: Colors.orange, size: 40),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                tip,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir una card de recetas saludables
  Widget _buildRecipeCard(String recipe) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.restaurant_menu, color: Colors.blue, size: 40),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                recipe,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
