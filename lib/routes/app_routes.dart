import 'package:flutter/material.dart';
import '../screens/app_info_screen.dart';
import '../screens/change_password/forgot_password_screen.dart';
import '../screens/change_password/new_password_screen.dart';
import '../screens/change_password/otp_verification_screen.dart';
import '../screens/deteccion_screen.dart';
import '../screens/detection_history_screen.dart';
import '../screens/edit_child_profile_screen.dart';
import '../screens/edit_user_profile_screen.dart';
import '../screens/feedback_screen.dart';
import '../screens/manage_child_profile_screen.dart';
import '../screens/notifications_settings_screen.dart';
import '../screens/nutri_recom.dart';
import '../screens/perfil_screen.dart';
import '../screens/recipes_screen.dart';
import '../screens/register_child_screen.dart';
import '../screens/result_detection_screen.dart';
import '../screens/security_settings_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/sign_in_screen.dart';
import '../screens/login_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/statistycs_screen.dart';
import '../screens/support_screen.dart';
import '../screens/take_or_pick_photo_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const login = "/login";
  static const signin = "/signin";
  static const appInfo = "/appinfo";
  static const initdetection = '/detection';
  static const detectionhistory = "/detectionhistory";
  static const editchildprofile = "/editchildprofile";
  static const edituserprofile = "/edituserprofile";
  static const userfeedback = '/userfeedback';
  static const managechild = "/managechild";
  static const notificationsettings = "/notificationsettings";
  static const nutritionrecomed = "/nutritionrecomed";
  static const profile = '/profile';
  static const privacypolicy = "/privacypolicy";
  static const recipes = "/recipes";
  static const registerchild = "/registerchild";
  static const detectionresult = '/detectionresult';
  static const securitysettings = "/securitysettings";
  static const profilesettings = "/settings";
  static const statistycs = "/statistycs";
  static const support = '/support';
  static const takeorpickphoto = "/takeorpickphoto";
  static const termandconditions = "/termandconditions";
  static const forgotpass = "/forgotpass";
  static const newpass = '/newpass';
  static const otpverification = "/otpverification";

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signin:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case appInfo:
        return MaterialPageRoute(builder: (_) => AppInfoScreen());
      case initdetection:
        return MaterialPageRoute(builder: (_) => DeteccionScreen());
      case detectionhistory:
        return MaterialPageRoute(builder: (_) => DetectionHistoryScreen());
      case edituserprofile:
        return MaterialPageRoute(builder: (_) => EditUserProfileScreen());
      case userfeedback:
        return MaterialPageRoute(builder: (_) => FeedbackScreen());
      case managechild:
        return MaterialPageRoute(builder: (_) => ManageChildProfileScreen());
      case notificationsettings:
        return MaterialPageRoute(builder: (_) => NotificationsSettingsScreen());
      case nutritionrecomed:
        return MaterialPageRoute(
            builder: (_) => NutritionalRecommendationsScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => PerfilScreen());
      case privacypolicy:
        return MaterialPageRoute(builder: (_) => PrivacyPolicyScreen());
      case recipes:
        return MaterialPageRoute(builder: (_) => RecipeScreen());
      case registerchild:
        return MaterialPageRoute(builder: (_) => RegisterChildScreen());
      case detectionresult:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ResultDetectionScreen.fromArguments(args),
        );
      case securitysettings:
        return MaterialPageRoute(builder: (_) => SecuritySettingsScreen());
      case profilesettings:
        return MaterialPageRoute(builder: (_) => ProfileSettingsScreen());
      case statistycs:
        return MaterialPageRoute(builder: (_) => GrowthChartsScreen());
      case support:
        return MaterialPageRoute(builder: (_) => SupportScreen());
      case takeorpickphoto:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => TakeOrPickPhotoScreen.fromArguments(args));
      case termandconditions:
        return MaterialPageRoute(builder: (_) => TermsAndConditionsScreen());
      case forgotpass:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case newpass:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => NewPasswordScreen.fromArguments(args));
      case otpverification:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen.fromArguments(args),
        );
      case editchildprofile:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => EditChildProfileScreen.fromArguments(args));
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Pantalla no encontrada')),
          ),
        );
    }
  }
}
