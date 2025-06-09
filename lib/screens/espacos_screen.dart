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
            
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  EspacoCard(nome: 'Quadra de Vôlei', icone: Icons.sports_volleyball),
                  EspacoCard(nome: 'Campo de Fut7', icone: Icons.sports_soccer),
                  EspacoCard(nome: 'Beach Tênis', icone: Icons.sports_tennis),
                  EspacoCard(nome: 'Ping Pong', icone: Icons.sports),
                  EspacoCard(nome: 'Piscina', icone: Icons.pool),
                  EspacoCard(nome: 'Ginásio', icone: Icons.sports_basketball),
                ],
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
