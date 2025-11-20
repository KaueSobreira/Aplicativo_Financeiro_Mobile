import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

void mostrarDialogCadastro(BuildContext context) {
  DateTime? dataSelecionada;
  final TextEditingController dataController = TextEditingController();
  String? categoriaSelecionada;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Nova Despesa"),
        content: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                const Text("Descrição da Despesa",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const TextField(
                  decoration: InputDecoration(hintText: "Descrição"),
                ),
                const SizedBox(height: 12),

                const Text("Valor",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(hintText: "Digite o Valor"),
                ),
                const SizedBox(height: 12),

                const Text("Data de Vencimento",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextField(
                  controller: dataController,
                  decoration: const InputDecoration(hintText: "Selecione a Data"),
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

                const Text("Categoria",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    hintText: "Selecione",
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
                  onChanged: (valor) {
                    categoriaSelecionada = valor;
                  },
                ),
                const SizedBox(height: 12),

                const Text("Comprovante",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                // -------------------- BOTÕES DE ANEXAR E TIRAR FOTO --------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text("Anexar"),
                      onPressed: () async {
                        FilePicker.platform.pickFiles();
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Foto"),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? foto =
                            await picker.pickImage(source: ImageSource.camera);

                        // Se quiser depois salvar esse caminho, você coloca aqui
                        if (foto != null) {
                          print("FOTO TIRADA: ${foto.path}");
                        }
                      },
                    ),
                  ],
                ),
                // -----------------------------------------------------------------------
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Fechar"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cadastrar"),
          ),
        ],
      );
    },
  );
}
