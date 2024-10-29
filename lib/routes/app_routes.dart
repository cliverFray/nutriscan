import 'package:flutter/material.dart';
import '../screens/sign_in_screen.dart';
import '../screens/login_screen.dart';

import '../screens/splash_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const login = "/login";
  static const signin = "/signin";

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashScreen(),
    login: (context) => LoginScreen(),
    signin: (context) => SignInScreen()
    //home: (context) => HomeScreen(),
  };
}
