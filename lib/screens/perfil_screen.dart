import 'package:flutter/material.dart';

import '../models/users.dart';
import '../services/user_service.dart';
import '../widgets/custom_title_text.dart';
import 'edit_user_profile_screen.dart';
import 'profile_settings_screen.dart';
import 'register_child_screen.dart';
import 'manage_child_profile_screen.dart';
import 'statistycs_screen.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    User? fetchedUser = await UserService().getCurrentUser();
    setState(() {
      user = fetchedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTitleText(text: 'Perfil'),
            SizedBox(height: 16),
            // Foto de perfil redonda
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                  'assets/images/foto_padre_niño.jpg'), // Cambia por la imagen real del perfil
            ),
            SizedBox(height: 16),
            // Nombre del usuario
            user != null
                ? Text(
                    user!.userFirstName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  )
                : Text(
                    'Cargando nombre...',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
            SizedBox(height: 30),
            // Opciones del perfil
            Expanded(
              child: ListView(
                children: [
                  // Editar perfil
                  ListTile(
                    leading: Icon(Icons.edit, color: Colors.black),
                    title:
                        Text('Editar Perfil', style: TextStyle(fontSize: 18)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Navegar a la pantalla de editar perfil
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditUserProfileScreen(
                            user: this.user!,
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(),

                  // Editar perfil del niño
                  ListTile(
                    leading: Icon(Icons.child_care, color: Colors.black),
                    title:
                        Text('Perfil del Niño', style: TextStyle(fontSize: 18)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Navegar a la pantalla de editar perfil del niño
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageChildProfileScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(),

                  // Ver gráficos
                  ListTile(
                    leading: Icon(Icons.bar_chart, color: Colors.black),
                    title: Text('Ver Gráficos de Crecimiento',
                        style: TextStyle(fontSize: 18)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Navegar a la pantalla de gráficos
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GrowthChartsScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(),

                  // Configuración
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.black),
                    title:
                        Text('Configuración', style: TextStyle(fontSize: 18)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Navegar a la pantalla de configuración
                    },
                  ),
                  Divider(),

                  // Cerrar sesión
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.black),
                    title:
                        Text('Cerrar Sesión', style: TextStyle(fontSize: 18)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Cerrar sesión y navegar a la pantalla de inicio de sesión
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
