import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroScreen extends StatefulWidget{
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  Future<void> salvarUsuario() async {
    if (nomeController.text.isEmpty || emailController.text.isEmpty || senhaController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos!')));
      return;
    }

    await FirebaseFirestore.instance.collection('cadastros').add({
      'nome': nomeController.text,
      'email': emailController.text,
      'senha': senhaController.text,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cadastro salvo com sucesso!')));

    nomeController.clear();
    emailController.clear();
    senhaController.clear();

    Navigator.pushNamed(context, '/listar');
  }

}