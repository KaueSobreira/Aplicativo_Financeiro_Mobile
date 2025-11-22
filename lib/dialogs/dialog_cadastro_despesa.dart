import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../models/despesa.dart';
import '../database/despesa_dao.dart';

// Adicionado parâmetro opcional despesaParaEditar
Future<void> mostrarDialogCadastro(BuildContext context, {Despesa? despesaParaEditar}) {
  DateTime? dataSelecionada;
  
  final descricaoController = TextEditingController();
  final valorController = TextEditingController();
  final dataController = TextEditingController();
  
  String? categoriaSelecionada;
  String? caminhoComprovante;
  
  final dao = DespesaDAO();

  // -- Lógica de Preenchimento para Edição --
  if (despesaParaEditar != null) {
    descricaoController.text = despesaParaEditar.descricao;
    valorController.text = despesaParaEditar.valor.toString();
    dataController.text = despesaParaEditar.dataVencimento;
    categoriaSelecionada = despesaParaEditar.categoria;
    caminhoComprovante = despesaParaEditar.comprovante;
    
    // Converter string de data para objeto DateTime para validação interna se necessário
    try {
      final parts = despesaParaEditar.dataVencimento.split('/');
      dataSelecionada = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    } catch (_) {}
  }

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(despesaParaEditar == null ? "Nova Despesa" : "Editar Despesa"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(hintText: "Descrição"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: valorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Valor"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dataController,
                decoration: const InputDecoration(hintText: "Data de Vencimento"),
                readOnly: true,
                onTap: () async {
                  DateTime? escolha = await showDatePicker(
                    context: context,
                    initialDate: dataSelecionada ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (escolha != null) {
                    dataSelecionada = escolha;
                    dataController.text = "${escolha.day}/${escolha.month}/${escolha.year}";
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: categoriaSelecionada, // Importante para mostrar o valor atual
                decoration: const InputDecoration(
                  hintText: "Categoria",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "Alimentação", child: Text("Alimentação")),
                  DropdownMenuItem(value: "Transporte", child: Text("Transporte")),
                  DropdownMenuItem(value: "Moradia", child: Text("Moradia")),
                  DropdownMenuItem(value: "Saúde", child: Text("Saúde")),
                  DropdownMenuItem(value: "Educação", child: Text("Educação")),
                  DropdownMenuItem(value: "Lazer", child: Text("Lazer")),
                  DropdownMenuItem(value: "Outros", child: Text("Outros")),
                ],
                onChanged: (valor) => categoriaSelecionada = valor,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo),
                    label: const Text("Anexar"),
                    onPressed: () async {
                      final arquivo = await FilePicker.platform.pickFiles();
                      if (arquivo != null) {
                        caminhoComprovante = arquivo.files.first.path!;
                      }
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Foto"),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final foto = await picker.pickImage(source: ImageSource.camera);
                      if (foto != null) caminhoComprovante = foto.path;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(
            child: Text(despesaParaEditar == null ? "Cadastrar" : "Salvar"),
            onPressed: () async {
              if (descricaoController.text.isEmpty || valorController.text.isEmpty || dataController.text.isEmpty || categoriaSelecionada == null) {
                return;
              }

              final despesa = Despesa(
                id: despesaParaEditar?.id, // Mantém o ID se for edição
                descricao: descricaoController.text,
                valor: double.tryParse(valorController.text) ?? 0,
                dataVencimento: dataController.text,
                categoria: categoriaSelecionada!,
                comprovante: caminhoComprovante,
              );

              if (despesaParaEditar == null) {
                await dao.inserir(despesa);
              } else {
                await dao.atualizar(despesa);
              }

              if (!context.mounted) return;
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}