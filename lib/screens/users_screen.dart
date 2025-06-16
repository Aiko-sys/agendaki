import 'package:flutter/material.dart';
import 'usuario_detalhes_screen.dart'; 

final Color laranja = const Color(0xFFF67828);

class Usuario {
  final String nome;
  final String email;
  final String tipo;

  Usuario({required this.nome, required this.email, required this.tipo});
}

class UsersScreen extends StatefulWidget {
  UsersScreen({Key? key}) : super(key: key);

  State<UsersScreen> createState() => _UsersScreenState();
}
class _UsersScreenState extends State<UsersScreen> {

  final List<Usuario> usuarios = [
    Usuario(nome: 'Nalyson Costa', email: 'nalysonmalvadin@gmail.com', tipo: 'Organização'),
    Usuario(nome: 'Kennedy Viana', email: 'Kenny1@email.com', tipo: 'Organização'),
    Usuario(nome: 'Carlos Eduardo', email: 'carlos1@email.com', tipo: 'Cliente'),
    Usuario(nome: 'kaik Oliveira', email: 'kaik1@email.com', tipo: 'Cliente'),
  ];

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

  Color _getTipoColor(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'organização':
        return Colors.blue;
      case 'aluno':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: laranja,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Clientes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(
                _getIcon(usuario.tipo),
                color: _getTipoColor(usuario.tipo),
                size: 36,
              ),
              title: Text(
                usuario.nome,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(usuario.email),
              trailing: Text(
                usuario.tipo,
                style: TextStyle(
                  color: _getTipoColor(usuario.tipo),
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsuarioDetalhesScreen(usuario: usuario),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
