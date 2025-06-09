import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './../services/user_service.dart';

import 'agendamento_screen.dart';

final Color laranja = const Color(0xFFF67828);

class EspacosScreen extends StatefulWidget {
  const EspacosScreen({Key? key}) : super(key: key);

  @override
  State<EspacosScreen> createState() => _EspacosScreenState();
}

class _EspacosScreenState extends State<EspacosScreen> {
  String? userName;
  String filtroBusca = '';

  final List<Map<String, dynamic>> espacos = [
    {'nome': 'Quadra de Vôlei', 'icone': Icons.sports_volleyball},
    {'nome': 'Campo de Fut7', 'icone': Icons.sports_soccer},
    {'nome': 'Beach Tênis', 'icone': Icons.sports_tennis},
    {'nome': 'Ping Pong', 'icone': Icons.sports},
    {'nome': 'Piscina', 'icone': Icons.pool},
    {'nome': 'futsal', 'icone': Icons.sports_basketball},
    {'nome': 'vôlei de areia', 'icone': Icons.sports_volleyball_outlined},
    {'nome': 'Pista de corrida', 'icone': Icons.sports_score_outlined},
  ];

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    final data = await UserService.loadUserData();
    if (data != null) {
      setState(() {
        userName = data['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final espacosFiltrados = espacos
        .where((e) =>
            e['nome'].toLowerCase().contains(filtroBusca.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: laranja,
        centerTitle: true,
        title: const Text(
          'Agendaki',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: laranja),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.account_circle, size: 60, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    '$userName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Início'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.event_note),
              title: const Text('Minhas Reservas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/minhas-reservas');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar espaço...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  filtroBusca = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: espacosFiltrados.map((espaco) {
                  return EspacoCard(
                    nome: espaco['nome'],
                    icone: espaco['icone'],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EspacoCard extends StatelessWidget {
  final String nome;
  final IconData icone;

  const EspacoCard({super.key, required this.nome, required this.icone});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/agendamento',
            arguments: nome,
          );
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icone, size: 48, color: laranja),
              const SizedBox(height: 8),
              Text(
                nome,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
