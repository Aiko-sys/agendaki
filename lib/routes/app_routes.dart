import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/espacos_screen.dart';
import '../screens/cadastro_screen.dart';
import './../widgets/auth_guard.dart';

class AppRoutes {
  static const String login = '/login';
  static const String espacos = '/espacos';
  static const String cadastro = '/cadastro';



  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      cadastro: (context) => const CadastroScreen(),
      espacos: (context) => AuthGuard(child: EspacosScreen()),
    };
  }
}
