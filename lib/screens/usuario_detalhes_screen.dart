import 'package:flutter/material.dart';
import 'users_screen.dart';

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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: laranja,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Editar Usuário'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {        
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Excluir Usuário'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'organização':
        return Icons.admin_panel_settings;
      case 'aluno':
        return Icons.school;
      default:
        return Icons.person;
    }
  }
}