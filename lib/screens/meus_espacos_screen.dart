import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final Color laranja = const Color(0xFFF67828);

class MeusEspacosScreen extends StatefulWidget {
  const MeusEspacosScreen({Key? key}) : super(key: key);

  @override
  State<MeusEspacosScreen> createState() => _MeusEspacosScreenState();
}

class _MeusEspacosScreenState extends State<MeusEspacosScreen> {
  late Future<List<Map<String, dynamic>>> _espacosFuturo;

  Future<List<Map<String, dynamic>>> carregarMeusEspacos() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('spaces')
        .where('user_id', isEqualTo: uid)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'nome': data['name'] ?? 'Sem nome',
      };
      }).toList();
  }

  @override
  void initState() {
    super.initState();
    _espacosFuturo = carregarMeusEspacos();
  }

  

  void deletarEspaco(String id) async {
    await FirebaseFirestore.instance.collection('spaces').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Espaço excluído.')),
    );
    setState(() {
      _espacosFuturo = carregarMeusEspacos();
    });
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
          'Meus Espaços',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _espacosFuturo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final espacos = snapshot.data ?? [];

          if (espacos.isEmpty) {
            return const Center(child: Text('Nenhum espaço encontrado.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: espacos.length,
            itemBuilder: (context, index) {
              final espaco = espacos[index];

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          espaco['nome'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Excluir espaço'),
                              content: const Text('Tem certeza que deseja excluir este espaço?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Excluir'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            deletarEspaco(espaco['id']);
                          }
                          setState(() {
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        icon: const Icon(Icons.delete),
                        label: const Text('Excluir'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final salvou = await Navigator.pushNamed(context, '/adicionar-espaco');
          if (salvou == true) {
            setState(() {
              _espacosFuturo = carregarMeusEspacos();
            });
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
