import 'package:flutter/material.dart';

class ResumoCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final Color corValor;

  const ResumoCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.corValor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black87,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              valor,
              style: TextStyle(
                color: corValor,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
