import 'package:flutter/material.dart';
import '../widgets/espaco_card.dart';

class EspacosScreen extends StatelessWidget {
  const EspacosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color laranja = const Color(0xFFF67828);

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
      body: ListView(
        children: const [
          SizedBox(height: 16),
          EspacoCard(icon: Icons.sports_volleyball, titulo: 'Quadras de Vôlei'),
          EspacoCard(icon: Icons.sports_soccer, titulo: 'Campos de Fut7'),
          EspacoCard(icon: Icons.beach_access, titulo: 'Arena de Beach Tênis'),
          EspacoCard(icon: Icons.sports_tennis, titulo: 'Mesas de Ping Pong'),
          EspacoCard(icon: Icons.pool, titulo: 'Piscinas'),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
