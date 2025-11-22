import 'dart:io';
import 'package:flutter/material.dart';
import '../models/despesa.dart';

class DespesaDetalhePage extends StatelessWidget {
  final Despesa despesa;

  const DespesaDetalhePage({super.key, required this.despesa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes da Despesa"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              color: Colors.grey[300],
              child: despesa.comprovante != null && despesa.comprovante!.isNotEmpty
                  ? Image.file(
                      File(despesa.comprovante!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Text("Erro ao carregar imagem"));
                      },
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                          Text("Sem comprovante"),
                        ],
                      ),
                    ),
            ),
            
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("Descrição", despesa.descricao, isBold: true),
                  const Divider(),
                  _buildInfoRow("Valor", "R\$ ${despesa.valor.toStringAsFixed(2)}", color: Colors.red, isBold: true),
                  const Divider(),
                  _buildInfoRow("Categoria", despesa.categoria),
                  const Divider(),
                  _buildInfoRow("Data de Vencimento", despesa.dataVencimento),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: color ?? Colors.black87,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}