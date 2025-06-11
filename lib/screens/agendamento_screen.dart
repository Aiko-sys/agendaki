import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class AgendamentoScreen extends StatefulWidget {
  final String nomeEspaco;

  const AgendamentoScreen({Key? key, required this.nomeEspaco}) : super(key: key);

  @override
  State<AgendamentoScreen> createState() => _AgendamentoScreenState();
}

class _AgendamentoScreenState extends State<AgendamentoScreen> {
  final Color laranja = const Color(0xFFF67828);
  final Color azul = const Color(0xFF2979FF);
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String? horarioSelecionado;
  String quadraSelecionada = 'Quadra Laranja';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, 
          ),
        title: Text('Agendar: ${widget.nomeEspaco}',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
            )
         ),
        backgroundColor: laranja,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                Text(
                  'Escolha a quadra e o horário para reservar o seu espaço.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                 Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Datas disponíveis',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800]),
                  ),
                ),
                const SizedBox(height: 16),

                TableCalendar(
                  firstDay: DateTime.utc(2025, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
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
                    child: Center(
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          '08:00', '09:00', '10:00', '11:00',
                          '14:00', '15:00', '16:00', '17:00',
                          '18:00', '19:00', '20:00'
                        ].map((horario) {
                          final selecionado = horarioSelecionado == horario;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                horarioSelecionado = horario;
                              });
                            },


                            child: Container(
                              width: screenWidth < 400 ? 100 : 120,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: selecionado ? azul : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: selecionado ? azul : Colors.grey.shade400),
                                boxShadow: selecionado
                                    ? [BoxShadow(color: azul.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 4))]
                                    : [],
                              ),
                              alignment: Alignment.center,
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
                ),
              ],
            ),
          );
        },
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
