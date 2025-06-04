import 'package:flutter/material.dart';

class EspacoCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final VoidCallback? onTap;

  const EspacoCard({
    super.key,
    required this.icon,
    required this.titulo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color laranja = const Color(0xFFF67828);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 32, color: laranja),
              const SizedBox(width: 16),
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: laranja,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
