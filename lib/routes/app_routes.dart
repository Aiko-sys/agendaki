import 'package:agendaki/screens/meus_espacos_screen.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/espacos_screen.dart';
import '../screens/cadastro_screen.dart';
import '../screens/agendamento_screen.dart';
import '../screens/mi_reservas.dart';
import '../screens/add_espacos_screen.dart';
import '../screens/perfilusuario_screen.dart';
import '../screens/users_screen.dart';
import '../screens/configuracoes_screen.dart';
import '../widgets/auth_guard.dart';

class AppRoutes {
  static const String login = '/login';
  static const String espacos = '/espacos';
  static const String cadastro = '/cadastro';
  static const String agendamento = '/agendamento';
  static const String minhasReservas = '/minhas-reservas';
  static const String adicionarEspaco = '/adicionar-espaco';
  static const String seusEspacos = '/meus-espacos';
  static const String perfilUsuario = '/perfil';
  static const String usuarios = '/usuarios';
  static const String configuracoes = '/config';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      cadastro: (context) => const CadastroScreen(),
      espacos: (context) => AuthGuard(child: const EspacosScreen()),
      agendamento: (context) {
        final args = ModalRoute.of(context)!.settings.arguments;
        if (args is List<String> && args.length >= 2) {
          return AgendamentoScreen(nomeEspaco: args[0], idEspaco: args[1]);
          
        } else {
          return const Scaffold(
            body: Center(child: Text('Nenhum espaço selecionado')),
          );
        }
      },
      minhasReservas: (context) =>
          AuthGuard(child: const MinhasReservasScreen()),
      seusEspacos: (context) =>
        AuthGuard(child: const MeusEspacosScreen()),
      adicionarEspaco: (context) =>
          AuthGuard(child: const AdicionarEspacoScreen()),
      // perfilUsuario: (context) =>
      //     AuthGuard(child: const PerfilUsuarioScreen()),
      // usuarios: (context) => AuthGuard(child: const UsersScreen()),
      configuracoes: (context) =>
          AuthGuard(child: const ConfiguracoesScreen()),

      usuarios: (context) => 
        AuthGuard(child: UsersScreen()),
    };
  }
}
