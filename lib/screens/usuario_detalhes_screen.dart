import 'package:flutter/material.dart';
import 'users_screen.dart'; // importa para reconhecer o tipo Usuario

class UsuarioDetalhesScreen extends StatelessWidget {
  final Usuario usuario;

  const UsuarioDetalhesScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color laranja = const Color(0xFFF67828);

    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nome),
        backgroundColor: laranja,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              _getIcon(usuario.tipo),
              size: 100,
              color: laranja,
            ),
            const SizedBox(height: 20),
            Text(
              'Nome: ${usuario.nome}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${usuario.email}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Tipo: ${usuario.tipo}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'administrador':
        return Icons.admin_panel_settings;
      case 'aluno':
        return Icons.school;
      default:
        return Icons.person;
    }
  }
}
