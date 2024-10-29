import 'package:flutter/material.dart';

class RecipeScreen extends StatelessWidget {
  final List<Map<String, String>> recipes = [
    {
      'name': 'Pachamanca Andina',
      'image':
          'assets/pachamanca.jpg', // Asegúrate de agregar esta imagen a tu carpeta de assets
      'description':
          'Un tradicional plato andino preparado bajo tierra con carne, papas y maíz, acompañado de hierbas locales como huacatay y chincho.',
      'ingredients':
          'Ingredientes: Carne de cordero, pollo, papa nativa, maíz, huacatay, chincho.',
    },
    {
      'name': 'Sopa de Quinua',
      'image': 'assets/sopa_quinua.jpg',
      'description':
          'Una nutritiva sopa hecha con quinua, el "grano de oro" de los Andes, acompañado de verduras frescas y hierbas locales.',
      'ingredients':
          'Ingredientes: Quinua, zanahoria, apio, papa, cebolla, ajo, perejil.',
    },
    {
      'name': 'Cuy Chactado',
      'image': 'assets/cuy_chactado.jpg',
      'description':
          'Un clásico de la gastronomía de Huancavelica, cuy frito acompañado de papas nativas y ensalada fresca.',
      'ingredients':
          'Ingredientes: Cuy, harina de maíz, aceite, papa nativa, ají, lechuga.',
    },
    {
      'name': 'Mazamorra de Calabaza',
      'image': 'assets/mazamorra_calabaza.jpg',
      'description':
          'Un postre nutritivo y saludable, elaborado con calabaza andina y canela, ideal para mantener una dieta balanceada.',
      'ingredients': 'Ingredientes: Calabaza, canela, azúcar, leche.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recetas Saludables'),
        backgroundColor: Color(0xFF83B56A), // Color del tema de tu app
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return _buildRecipeCard(
              name: recipe['name']!,
              imagePath: recipe['image']!,
              description: recipe['description']!,
              ingredients: recipe['ingredients']!,
            );
          },
        ),
      ),
    );
  }

  // Método para construir la card de cada receta
  Widget _buildRecipeCard({
    required String name,
    required String imagePath,
    required String description,
    required String ingredients,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del platillo
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),

            // Nombre del platillo
            Text(
              name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            // Descripción del platillo
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),

            // Ingredientes
            Text(
              ingredients,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),

            // Botón para ver más detalles
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Acción para ver más detalles sobre la receta
                  },
                  child: Text('Ver detalles'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF83B56A),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
