import 'package:flutter/material.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({Key? key}) : super(key: key);

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  final Color laranja = const Color(0xFFF67828);
  bool notificacoesAtivadas = true;
  bool temaEscuro = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: laranja,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Preferências',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Notificações'),
            value: notificacoesAtivadas,
            onChanged: (value) {
              setState(() {
                notificacoesAtivadas = value;
              });
            },
            activeColor: laranja,
          ),
          SwitchListTile(
            title: const Text('Tema escuro'),
            value: temaEscuro,
            onChanged: (value) {
              setState(() {
                temaEscuro = value;
              });
            },
            activeColor: laranja,
          ),
          const SizedBox(height: 24),
          const Text(
            'Conta',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Alterar senha'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funcionalidade em desenvolvimento.')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Excluir conta'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funcionalidade em desenvolvimento.')),
              );
            },
          ),
        ],
      ),
    );
  }
}
