import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/espacos_screen.dart';
import '../screens/cadastro_screen.dart';
import '../screens/agendamento_screen.dart';
import '../screens/mi_reservas.dart';
import '../screens/add_espacos_screen.dart';
import '../screens/perfilusuario_screen.dart';
import '../screens/users_screen.dart'; 
import './../widgets/auth_guard.dart';
import './../models/agendamento.dart';
import './../models/usuario.dart';

class AppRoutes {
  static const String login = '/login';
  static const String espacos = '/espacos';
  static const String cadastro = '/cadastro';
  static const String agendamento = '/agendamento';
  static const String minhasReservas = '/minhas-reservas';
  static const String adicionarEspaco = '/adicionar-espaco';
  static const String perfilUsuario = '/perfilusuario';
  static const String usuarios = '/usuarios'; 

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),

      cadastro: (context) => const CadastroScreen(),
      
      // perfilUsuario: (context) => const PerfilUsuarioScreen(usuario: Usuario.new(email: 'email@email.com', nome: 'User', tipo: 'Cliente'), agendamentos: [Agendamento.new],),

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

      minhasReservas: (context) =>
          AuthGuard(child: const MinhasReservasScreen()),

      adicionarEspaco: (context) =>
          AuthGuard(child: const AdicionarEspacoScreen()),

      // perfilUsuario: (context) => 
      //   AuthGuard(child: const PerfilUsuarioScreen(usuario: Usuario.new(email: ), agendamentos: 'agendamentos'))

      usuarios: (context) => AuthGuard(child: UsersScreen()), // 

    };
  }
}
