import 'package:flutter/material.dart';

final Color laranja = const Color(0xFFF67828);

class MinhasReservasScreen extends StatelessWidget {
  const MinhasReservasScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> reservas = const [
    {
      'espaco': 'Quadra de Vôlei',
      'data': '12/06/2025',
      'hora': '16:00 - 17:00',
      'status': 'Confirmado',
    },
    {
      'espaco': 'Piscina',
      'data': '13/06/2025',
      'hora': '14:00 - 15:00',
      'status': 'cancelado',
    },
    {
      'espaco': 'Ping Pong',
      'data': '15/06/2025',
      'hora': '10:00 - 11:00',
      'status': 'Cancelado',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: laranja,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); 
          },
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
      body: ListView.builder(
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      Icon(Icons.info_outline, color: statusColor, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        reserva['status'] ?? '',
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
