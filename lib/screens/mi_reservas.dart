import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './../services/appointment_service.dart';

final Color laranja = const Color(0xFFF67828);

class MinhasReservasScreen extends StatefulWidget {
  const MinhasReservasScreen({Key? key}) : super(key: key);

  @override
  State<MinhasReservasScreen> createState() => _MinhasReservasScreenState();
}

class _MinhasReservasScreenState extends State<MinhasReservasScreen> {
  late Future<List<Map<String, dynamic>>> _reservasFuturo;

  @override
  void initState() {
    super.initState();
    _reservasFuturo = buscarReservas();
  }

  Future<List<Map<String, dynamic>>> buscarReservas() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('user_id', isEqualTo: user.uid)
        .get();

    List<Map<String, dynamic>> reservas = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      data['id'] = doc.id;

      // Busca nome do espaço
      final spaceSnapshot = await FirebaseFirestore.instance
          .collection('spaces')
          .doc(data['space_id'])
          .get();

      final nomeEspaco = spaceSnapshot.data()?['name'] ?? 'Espaço desconhecido';

      // Divide a data e hora
      final timestamp = data['date'] as Timestamp;
      final date = timestamp.toDate();

      final dataFormatada =
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      final horaFormatada =
          '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} - ${date.add(Duration(hours: 1)).hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

      reservas.add({
        'id': data['id'],
        'espaco': nomeEspaco,
        'data': dataFormatada,
        'hora': horaFormatada,
        'status': data['status'],
      });
    }

    return reservas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: laranja,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Minhas Reservas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _reservasFuturo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final reservas = snapshot.data ?? [];

          if (reservas.isEmpty) {
            return const Center(child: Text('Nenhuma reserva encontrada.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reservas.length,
            itemBuilder: (context, index) {
              final reserva = reservas[index];

              Color statusColor;
              switch (reserva['status']) {
                case 'Confirmado':
                  statusColor = Colors.green;
                  break;
                case 'Pendente':
                  statusColor = Colors.orange;
                  break;
                case 'Cancelado':
                  statusColor = Colors.red;
                  break;
                default:
                  statusColor = Colors.grey;
              }

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reserva['espaco'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 6),
                          Text(reserva['data'] ?? ''),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 6),
                          Text(reserva['hora'] ?? ''),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: statusColor, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            reserva['status'] ?? '',
                            style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: TextButton(
                              onPressed: () async {
                                final bool? confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirmação'),
                                    content: const Text('Tem certeza que quer cancelar?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('Não'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text('Sim'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  AppointmentService.deleteAppointment(reserva['id']);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Reserva cancelada.')),
                                  );
                                  setState(() {
                                    _reservasFuturo = buscarReservas();
                                  });
                                }

                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.cancel),
                                  const Text('Cancelar'),
                                ],
                              ),
                          ),
                          )
                        ],
                        
                      ),
                      
                    ],
                    
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
