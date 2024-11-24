import 'package:flutter/material.dart';

import '../models/users.dart';
import '../models/user_profile.dart';
import '../services/user_service.dart';
import '../widgets/custom_title_text.dart';
import 'edit_user_profile_screen.dart';
import 'login_screen.dart';
import 'profile_settings_screen.dart';
import 'register_child_screen.dart';
import 'manage_child_profile_screen.dart';
import 'settings_screen.dart';
import 'statistycs_screen.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  UserProfile? user;
  bool isLoading = true; // Nuevo estado de carga
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      UserProfile? fetchedUser = await _userService.getUserProfile();

      setState(() {
        user = fetchedUser;
        isLoading = false;
      });

      if (fetchedUser == null) {
        _showUnauthorizedMessage();
        // Utiliza `Future.microtask` para asegurarte de que el estado ya ha cambiado antes de navegar
        Future.microtask(() => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            ));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar("Error al cargar perfil: $e", isError: true);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showUnauthorizedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Sesión expirada. Inicia sesión nuevamente."),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _logout() async {
    await _userService.logoutUser(); // Cierra sesión y limpia datos
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false, // Remueve todas las rutas anteriores
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(
                child:
                    CircularProgressIndicator()) // Muestra indicador de carga
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTitleText(text: 'Perfil'),
                  SizedBox(height: 16),
                  // Foto de perfil redonda
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(
                        'assets/images/happyfamily.jpg'), // Cambia por la imagen real del perfil
                  ),
                  SizedBox(height: 16),
                  // Nombre del usuario
                  user != null
                      ? Column(
                          children: [
                            Text(
                              '${user!.userFirstName} ${user!.userLastName}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'DNI: ${user!.userDNI ?? 'No disponible'}',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                            Text(
                              'Teléfono: ${user!.userPhone ?? 'No disponible'}',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                            Text(
                              'Lugar: ${user!.userPlace ?? 'No disponible'}',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                          ],
                        )
                      : Text(
                          'No se pudo cargar el perfil.',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                  SizedBox(height: 30),
                  // Opciones del perfil
                  Expanded(
                    child: ListView(
                      children: [
                        // Editar perfil
                        ListTile(
                          leading: Icon(Icons.edit, color: Colors.black),
                          title: Text('Editar Perfil',
                              style: TextStyle(fontSize: 18)),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: Colors.grey),
                          onTap: () {
                            // Navegar a la pantalla de editar perfil
                            if (user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditUserProfileScreen(),
                                ),
                              );
                            }
                          },
                        ),
                        Divider(),

                        // Editar perfil del niño
                        ListTile(
                          leading: Icon(Icons.child_care, color: Colors.black),
                          title: Text('Perfil del Niño',
                              style: TextStyle(fontSize: 18)),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: Colors.grey),
                          onTap: () {
                            // Navegar a la pantalla de editar perfil del niño
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ManageChildProfileScreen(),
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
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: Colors.grey),
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
                          title: Text('Configuración',
                              style: TextStyle(fontSize: 18)),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: Colors.grey),
                          onTap: () {
                            // Navegar a la pantalla de configuración
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileSettingsScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(),

                        // Cerrar sesión
                        ListTile(
                          leading: Icon(Icons.logout, color: Colors.black),
                          title: Text('Cerrar Sesión',
                              style: TextStyle(fontSize: 18)),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: Colors.grey),
                          onTap: () async {
                            await _logout();
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
