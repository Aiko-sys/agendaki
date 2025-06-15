import 'package:agendaki/services/space_service.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './../services/appointment_service.dart';

class AgendamentoScreen extends StatefulWidget {
  final String nomeEspaco;
  final String idEspaco;

  const AgendamentoScreen({Key? key, required this.nomeEspaco, required this.idEspaco}) : super(key: key);

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
  Map<String, List<String>> disponibilidadePorData = {};
  bool loading = true;

  String _formatarData(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  String _formatarHora(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void loadSpace() async {
    final spaceData = await SpaceService.loadSpaceData(widget.idEspaco);

    if(spaceData == null){
      setState(() {
        loading = false;
      });
      return;
    } 

    final availabilityTimestamps = List<Timestamp>.from(spaceData['availability'] ?? []);
    final availability = availabilityTimestamps.map((ts) => ts.toDate()).toList();

    for (var dateTime in availability) {
      final dataStr = _formatarData(dateTime);
      final horaStr = _formatarHora(dateTime);

      disponibilidadePorData.putIfAbsent(dataStr, () => []);
      disponibilidadePorData[dataStr]!.add(horaStr);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadSpace();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dataSelecionadaStr = _selectedDay != null ? _formatarData(_selectedDay!) : '';
    final horariosDoDia = disponibilidadePorData[dataSelecionadaStr] ?? [];      

    if(loading){
      return const Center(child: CircularProgressIndicator());
    }

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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Escolha data e o horário para reservar o seu espaço.',
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

                  SizedBox(
                    height: 350, 
                    child: TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) {
                        if (_selectedDay == null) return false;
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                          
                        });
                      },
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ), 
                        todayTextStyle: const TextStyle(
                          color: Colors.black,
                        )
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Horários disponíveis',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800]),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                  height: 150,
                  child: SingleChildScrollView(
                    child: Center(
                      child: horariosDoDia.isEmpty
                          ? const Text(
                              'Sem horários disponíveis',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            )
                          : Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: horariosDoDia.map((horario) {
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
            onPressed: horarioSelecionado == null || _selectedDay == null
              ? null
              : () async {
                  final partesHora = horarioSelecionado!.split(':');
                  final int hora = int.parse(partesHora[0]);
                  final int minuto = int.parse(partesHora[1]);
                  final user = FirebaseAuth.instance.currentUser;

                  final DateTime dataHoraAgendada = DateTime(
                    _selectedDay!.year,
                    _selectedDay!.month,
                    _selectedDay!.day,
                    hora,
                    minuto,
                    0,
                    0
                  );

                  final data = {
                    'space_id': widget.idEspaco,
                    'status': 'Confirmado',
                    'date': Timestamp.fromDate(dataHoraAgendada),
                    'user_id': user?.uid
                  };
                  
                  final idReserva = await AppointmentService.createAppointment(data);

                  await FirebaseFirestore.instance.collection('spaces').doc(widget.idEspaco).update({
                    'availability': FieldValue.arrayRemove([Timestamp.fromDate(dataHoraAgendada)])
                  });
                  
                  final msg = 'Reservado ${widget.nomeEspaco} - ${_formatarData(_selectedDay!)} às $horarioSelecionado';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                  Navigator.pop(context);
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
