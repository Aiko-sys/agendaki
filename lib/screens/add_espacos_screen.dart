import 'package:flutter/material.dart';
import 'dart:math';

final Color laranja = const Color(0xFFF67828);

class Espaco {
  final String id;
  final String nome;
  final String descricao;
  final List<DateTime> disponibilidade;

  Espaco({
    required this.id,
    required this.nome,
    required this.descricao,
    this.disponibilidade = const [],
  });
}

class AdicionarEspacoScreen extends StatefulWidget {
  const AdicionarEspacoScreen({Key? key}) : super(key: key);

  @override
  State<AdicionarEspacoScreen> createState() => _AdicionarEspacoScreenState();
}

class _AdicionarEspacoScreenState extends State<AdicionarEspacoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  IconData? _iconeSelecionado;

  final List<IconData> iconesDisponiveis = [
    Icons.sports_soccer,
    Icons.pool,
    Icons.sports_volleyball,
    Icons.sports_tennis,
    Icons.directions_run,
    Icons.sports_basketball,
    Icons.sports,
  ];

  String _gerarIdAleatorio() {
    final random = Random();
    return String.fromCharCodes(List.generate(8, (index) => random.nextInt(33) + 89));
  }

  void _salvarEspaco() {
    if (_formKey.currentState!.validate() && _iconeSelecionado != null) {
      final novoEspaco = Espaco(
        id: _gerarIdAleatorio(),
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        disponibilidade: [],
      );

      Navigator.pop(context, {'espaco': novoEspaco, 'icone': _iconeSelecionado});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos e escolha um ícone.')),
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
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
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
              const Text(
                'Nome do Espaço',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  hintText: 'Ex: Campo de Futebol',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Digite o nome do espaço' : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Descrição ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descricaoController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Ex: Grama sintetica,  18 x 36.',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Escolha um ícone',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: iconesDisponiveis.map((icon) {
                  final isSelected = _iconeSelecionado == icon;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _iconeSelecionado = icon;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? laranja : Colors.white,
                        border: Border.all(
                          color: isSelected ? laranja : Colors.grey.shade300,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: laranja.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        size: 28,
                        color: isSelected ? Colors.white : laranja,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvarEspaco,
                  icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                  label: const Text(
                    'Salvar Espaço',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: laranja,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 4,
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
