import 'package:flutter/material.dart';

final Color laranja = const Color(0xFFF67828);

class Usuario {
  final String id;
  final String nome;
  final String email;
  final String tipo;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipo,
  });
}

class Agendamento {
  final String id;
  final String espacoNome;
  final DateTime dataHora;
  final String status;

  Agendamento({
    required this.id,
    required this.espacoNome,
    required this.dataHora,
    required this.status,
  });
}

class PerfilUsuarioScreen extends StatelessWidget {
  final Usuario usuario;
  final List<Agendamento> agendamentos;

  const PerfilUsuarioScreen({
    Key? key,
    required this.usuario,
    required this.agendamentos,
  }) : super(key: key);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmado':
        return Colors.green;
      case 'pendente':
        return Colors.orange;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmado':
        return Icons.check_circle;
      case 'pendente':
        return Icons.hourglass_top;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de ${usuario.nome}'),
        backgroundColor: laranja,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text(
              usuario.nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(usuario.email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),

            const Text(
              'Histórico de Agendamentos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: agendamentos.isEmpty
                  ? const Center(child: Text('Nenhum agendamento encontrado.'))
                  : ListView.builder(
                      itemCount: agendamentos.length,
                      itemBuilder: (context, index) {
                        final agendamento = agendamentos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Icon(
                              _statusIcon(agendamento.status),
                              color: _statusColor(agendamento.status),
                              size: 32,
                            ),
                            title: Text(agendamento.espacoNome),
                            subtitle: Text(
                              '${agendamento.dataHora.toLocal()}'.split('.')[0],
                            ),
                            trailing: Text(
                              agendamento.status[0].toUpperCase() + agendamento.status.substring(1),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _statusColor(agendamento.status),
                              ),
                            ),
                          ),
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
