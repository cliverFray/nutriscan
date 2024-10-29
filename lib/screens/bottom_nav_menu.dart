import 'package:flutter/material.dart';

import 'deteccion_screen.dart';
import 'nutriRecom.dart';
import 'perfil_screen.dart';

class BottomNavMenu extends StatefulWidget {
  @override
  _BottomNavMenuState createState() => _BottomNavMenuState();
}

class _BottomNavMenuState extends State<BottomNavMenu> {
  int _selectedIndex = 0;

  // Lista de los widgets que corresponden a cada sección
  final List<Widget> _widgetOptions = [
    HomeScreen(),
    DeteccionScreen(),
    NutritionalRecommendationsScreen(
      childName: "Juan",
      nutritionalStatus: "Saludable",
      personalizedRecommendations: [
        "Continúa ofreciendo una dieta variada con frutas, verduras, proteínas y carbohidratos complejos.",
        "Incluye fuentes de hierro como carne roja, espinacas y legumbres.",
      ],
      generalTips: [
        "Ofrece agua potable constantemente durante el día.",
        "Evita el exceso de azúcar y grasas saturadas.",
      ],
      healthyRecipes: [
        "Ensalada de verduras frescas con pollo a la parrilla.",
        "Sopa de lentejas con zanahoria y espinacas.",
      ],
    ),
    AsistenteVirtualScreen(),
    PerfilScreen(),
  ];

  // Método para cambiar el índice cuando el usuario selecciona una opción
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF83B56A),
        automaticallyImplyLeading: false, // Oculta la flecha de retroceso
        centerTitle: true, // Para centrar el título
        title: Text(
          'NutriScan',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Título en negrita
            fontSize: 20, // Tamaño del texto
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF83B56A), // Color de la opción seleccionada
        unselectedItemColor:
            Colors.grey, // Color de las opciones no seleccionadas
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Detección',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining),
            label: 'Recomendaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Asistente',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// Pantallas de ejemplo (debes reemplazar estas pantallas con los widgets reales que deseas para cada sección)
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Home Screen'));
  }
}

class AsistenteVirtualScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Asistente virtual'));
  }
}
