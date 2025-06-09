import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/espacos_screen.dart';
import '../screens/cadastro_screen.dart';
import '../screens/agendamento_screen.dart';
import '../screens/agendamento_screen.dart';
import './../widgets/auth_guard.dart';

class AppRoutes {
  static const String login = '/login';
  static const String espacos = '/espacos';
  static const String cadastro = '/cadastro';
  static const String agendamento = '/agendamento';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      // cadastro: (context) => const CadastroScreen(), // Ative quando for usar
      espacos: (context) => AuthGuard(child: const EspacosScreen()),
      agendamento: (context) {
        final args = ModalRoute.of(context)!.settings.arguments;
        if (args is String) {
          return AgendamentoScreen(nomeEspaco: args);
        } else {
          return const Scaffold(
            body: Center(child: Text('Nenhum espaço selecionado')),
          );
        }
      },
      cadastro: (context) => const CadastroScreen(),
      espacos: (context) => AuthGuard(child: EspacosScreen()),

      cadastro: (context) => const CadastroScreen(),
      espacos: (context) => AuthGuard(child: EspacosScreen()),
    };
  }
}
