import 'package:flutter/material.dart';


class AgendamentoScreen extends StatefulWidget {
  final String nomeEspaco;

  const AgendamentoScreen({Key? key, required this.nomeEspaco}) : super(key: key);

  @override
  State<AgendamentoScreen> createState() => _AgendamentoScreenState();
}

class _AgendamentoScreenState extends State<AgendamentoScreen> {
  final Color laranja = const Color(0xFFF67828);
  final Color azul = const Color(0xFF2979FF);

  String? horarioSelecionado;
  String quadraSelecionada = 'Quadra Laranja';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar: ${widget.nomeEspaco}'),
        backgroundColor: laranja,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/quadra.png',
              height: 96,
              width: 96,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              'Escolha a quadra e o horário para reservar o seu espaço.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['Quadra Laranja', 'Quadra Azul'].map((quadra) {
                final selecionado = quadraSelecionada == quadra;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      quadraSelecionada = quadra;
                      horarioSelecionado = null; // Limpa horário quando muda quadra
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: selecionado ? azul : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: selecionado ? azul : Colors.grey.shade400),
                      boxShadow: selecionado
                          ? [BoxShadow(color: azul.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 4))]
                          : [],
                    ),
                    child: Text(
                      quadra,
                      style: TextStyle(
                        color: selecionado ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Horários disponíveis',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800]),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    '08:00', '09:00', '10:00', '11:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00'
                  ].map((horario) {
                    final selecionado = horarioSelecionado == horario;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          horarioSelecionado = horario;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          color: selecionado ? azul : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: selecionado ? azul : Colors.grey.shade400),
                          boxShadow: selecionado
                              ? [BoxShadow(color: azul.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 4))]
                              : [],
                        ),
                        child: Text(
                          horario,
                          style: TextStyle(
                            color: selecionado ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: laranja,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            ),
            onPressed: horarioSelecionado == null
                ? null
                : () {
                    final msg =
                        'Reservado ${widget.nomeEspaco} - $quadraSelecionada para o horário $horarioSelecionado';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(msg)),
                    );
                  },
            child: const Text(
              'Reservar',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
