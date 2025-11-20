import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../models/despesa.dart';
import '../database/despesa_dao.dart';

void mostrarDialogCadastro(BuildContext context) {
  DateTime? dataSelecionada;

  final descricaoController = TextEditingController();
  final valorController = TextEditingController();
  final dataController = TextEditingController();

  String? categoriaSelecionada;
  String? caminhoComprovante;

  final dao = DespesaDAO();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Nova Despesa"),
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
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (escolha != null) {
                    dataSelecionada = escolha;
                    dataController.text =
                        "${escolha.day}/${escolha.month}/${escolha.year}";
                  }
                },
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
          TextButton(
            child: const Text("Cadastrar"),
            onPressed: () async {
              if (descricaoController.text.isEmpty ||
                  valorController.text.isEmpty ||
                  dataSelecionada == null ||
                  categoriaSelecionada == null) {
                return;
              }

              final novaDespesa = Despesa(
                descricao: descricaoController.text,
                valor: double.tryParse(valorController.text) ?? 0,
                dataVencimento: dataController.text,
                categoria: categoriaSelecionada!,
                comprovante: caminhoComprovante,
              );

              await dao.inserir(novaDespesa);

              if (!context.mounted) return;
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
