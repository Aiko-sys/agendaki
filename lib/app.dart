// lib/app.dart
import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'screens/login_screen.dart';

class AgendakiApp extends StatelessWidget {
  const AgendakiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agendaki',
      debugShowCheckedModeBanner: false,  
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
   
      },
    );
  }
}
