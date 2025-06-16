import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/user_service.dart';

final Color laranja = const Color(0xFFF67828);
final Color backgroundColor = Colors.white;

class EspacosScreen extends StatefulWidget {
  const EspacosScreen({Key? key}) : super(key: key);

  @override
  State<EspacosScreen> createState() => _EspacosScreenState();
}

class _EspacosScreenState extends State<EspacosScreen> {
  String? userName;
  String? userType;
  String filtroBusca = '';

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
        userType = data['type'];
      });
    }
  }

  Future<List<Map<String, dynamic>>> carregarEspacos() async {
    final snapshot = await FirebaseFirestore.instance.collection('spaces').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'space_id': doc.id,
        'nome': data['name'] ?? 'Sem nome',
        'icone': _iconePorNome(data['name'] ?? ''),
      };
    }).toList();
  }

  IconData _iconePorNome(String nome) {
    final nomeLower = nome.toLowerCase();
    if (nomeLower.contains('vôlei')) return Icons.sports_volleyball;
    if (nomeLower.contains('fut')) return Icons.sports_soccer;
    if (nomeLower.contains('tênis')) return Icons.sports_tennis;
    if (nomeLower.contains('ping') || nomeLower.contains('pong')) return Icons.sports;
    if (nomeLower.contains('deck')) return Icons.pool;
    if (nomeLower.contains('basquete')) return Icons.sports_basketball;
    if (nomeLower.contains('areia')) return Icons.sports_volleyball_outlined;
    if (nomeLower.contains('pista')) return Icons.directions_run;
    return Icons.sports;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: laranja,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
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
                    userName ?? 'Usuário',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tipo: ${userType ?? 'Sem Informação'}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
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
            if (userType == 'Organização')
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('Meus espaços'),
                onTap: () async {
                  Navigator.pop(context);
                  final novoEspaco = await Navigator.pushNamed(
                    context,
                    '/meus-espacos',
                  );
                  if (novoEspaco != null && mounted) {
                    setState(() {});
                  }
                },
              ),
            if (userType == 'Organização')
              ListTile(
                leading: const Icon(Icons.supervised_user_circle_sharp),
                title: const Text('Ver clientes'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/usuarios');
                },
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
              leading: const Icon(Icons.account_circle_rounded),
              title: const Text('Meu perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/perfil');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/config');
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
      body: Container(
        color: backgroundColor,
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
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: carregarEspacos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar espaços.'));
                  }

                  final espacos = snapshot.data ?? [];

                  final espacosFiltrados = espacos.where((espaco) {
                    return espaco['nome']
                        .toLowerCase()
                        .contains(filtroBusca.toLowerCase());
                  }).toList();

                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: espacosFiltrados.map((espaco) {
                      return EspacoCard(
                        nome: espaco['nome'],
                        icone: espaco['icone'],
                        id: espaco['space_id'],
                      );
                    }).toList(),
                  );
                },
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
  final String id;
  final IconData icone;

  const EspacoCard(
      {super.key, required this.nome, required this.icone, required this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/agendamento',
            arguments: [nome, id],
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
