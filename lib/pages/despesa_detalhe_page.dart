import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../models/despesa.dart';
import '../database/despesa_dao.dart';
import '../dialogs/dialog_cadastro_despesa.dart';

class DespesaDetalhePage extends StatefulWidget {
  final Despesa despesa;

  const DespesaDetalhePage({super.key, required this.despesa});

  @override
  State<DespesaDetalhePage> createState() => _DespesaDetalhePageState();
}

class _DespesaDetalhePageState extends State<DespesaDetalhePage> {
  late Despesa _despesaAtual;
  final DespesaDAO _dao = DespesaDAO();
  
  final _formatadorMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void initState() {
    super.initState();
    _despesaAtual = widget.despesa;
  }

  Future<void> _confirmarExclusao() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir Despesa"),
        content: const Text("Tem certeza que deseja excluir esta despesa?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Excluir", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmar == true) {
      await _dao.excluir(_despesaAtual.id!);
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  Future<void> _editarDespesa() async {
    await mostrarDialogCadastro(context, despesaParaEditar: _despesaAtual);
    
    final listaAtualizada = await _dao.listar();
    final despesaRecarregada = listaAtualizada.firstWhere((d) => d.id == _despesaAtual.id, orElse: () => _despesaAtual);

    setState(() {
      _despesaAtual = despesaRecarregada;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes da Despesa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: _editarDespesa,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _confirmarExclusao,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              color: Colors.grey[300],
              child: _despesaAtual.comprovante != null && _despesaAtual.comprovante!.isNotEmpty
                  ? Image.file(
                      File(_despesaAtual.comprovante!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(child: Text("Erro ao carregar imagem")),
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
                  _buildInfoRow("Descrição", _despesaAtual.descricao, isBold: true),
                  const Divider(),
                  
                  _buildInfoRow(
                    "Valor", 
                    _formatadorMoeda.format(_despesaAtual.valor), 
                    color: Colors.red, 
                    isBold: true
                  ),
                  
                  const Divider(),
                  _buildInfoRow("Categoria", _despesaAtual.categoria),
                  const Divider(),
                  _buildInfoRow("Data de Vencimento", _despesaAtual.dataVencimento),
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