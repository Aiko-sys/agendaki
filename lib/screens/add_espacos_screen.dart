import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';

final Color laranja = const Color(0xFFF67828);

class AdicionarEspacoScreen extends StatefulWidget {
  const AdicionarEspacoScreen({Key? key}) : super(key: key);

  @override
  State<AdicionarEspacoScreen> createState() => _AdicionarEspacoScreenState();
}

class _AdicionarEspacoScreenState extends State<AdicionarEspacoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final Map<DateTime, List<TimeOfDay>> _horariosPorDia = {};
  DateTime _diaSelecionado = DateTime.now();
  final List<DateTime> _diasSelecionados = [];
  void _selecionarHorario() async {
    final TimeOfDay? horario = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (horario != null) {
      setState(() {
        _horariosPorDia.putIfAbsent(_diaSelecionado, () => []);
        _horariosPorDia[_diaSelecionado]!.add(horario);
      });
    }
  }

  void _salvarEspaco() async {
    if (_formKey.currentState!.validate()) {
       final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não autenticado.')),
        );
        return;
      }

      final List<Timestamp> disponibilidadeTimestamps = [];

      _horariosPorDia.forEach((dia, horarios) {
        for (var horario in horarios) {
          final dataHora = DateTime(
            dia.year,
            dia.month,
            dia.day,
            horario.hour,
            horario.minute,
          );
          disponibilidadeTimestamps.add(Timestamp.fromDate(dataHora));
        }
      });

      await FirebaseFirestore.instance.collection('spaces').add({
        'name': _nomeController.text,
        'description': _descricaoController.text,
        'availability': disponibilidadeTimestamps,
        'user_id': user.uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Espaço salvo com sucesso!')),
      );

      Navigator.pop(context, true); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos e selecione pelo menos uma data e horário.')),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: laranja,
        title: const Text(
          'Adicionar Espaço',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nome do Espaço'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(hintText: 'Ex: Campo de Futebol'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Digite o nome do espaço' : null,
              ),
              const SizedBox(height: 24),
              const Text('Descrição'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(hintText: 'Ex: Grama sintética, 18 x 36.'),
              ),
              const SizedBox(height: 24),
              const Text('Disponibilidade'),
              const SizedBox(height: 8),
              TableCalendar(
                focusedDay: _diaSelecionado,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                selectedDayPredicate: (day) => isSameDay(_diaSelecionado, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _diaSelecionado = selectedDay;
                  });
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _selecionarHorario,
                child: const Text('Adicionar horário'),
              ),
              const SizedBox(height: 8),
              if (_horariosPorDia[_diaSelecionado] != null)
                Wrap(
                  spacing: 8,
                  children: _horariosPorDia[_diaSelecionado]!
                      .map((hora) => Chip(
                            label: Text('${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}'),
                          ))
                      .toList(),
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvarEspaco,
                  icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                  label: const Text('Salvar Espaço', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: laranja,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
