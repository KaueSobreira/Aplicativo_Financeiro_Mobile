import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExpenseListPage(),
    );
  }
}

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                mostrarDialogCadastro();
              },
              child: Icon(Icons.add, size: 40, color: Colors.blue,),
            ),
          ],
        ),
      ),
    );
  }

  // Método que mostra o dialog de cadastro
  void mostrarDialogCadastro() {
    DateTime? dataSelecionada;
    final TextEditingController dataController = TextEditingController();
    String? categoriaSelecionada;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Nova Despesa"),
          content: SizedBox(
            width: 600,
            height: 500,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 12,),
            
                Text("Descrição da Despesa", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
            
                SizedBox(height: 12,),
            
                TextField(
                  decoration: InputDecoration(hintText: "Descrição"),
                ),
            
                SizedBox(height: 12,),
            
                Text("Valor", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
            
                SizedBox(height: 12,),
            
                TextField(
                  decoration: InputDecoration(hintText: "Digite o Valor"),
                ),
            
                SizedBox(height: 12,),
            
                Text("Data de Vencimento", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
            
                SizedBox(height: 12,),
            
                TextField(
                  controller: dataController,
                  decoration: InputDecoration(hintText: "Selecione a Data"),
                  readOnly: true,
                  onTap: () async {
                    DateTime? dataEscolhida = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    
                    if (dataEscolhida != null) {
                      setState(() {
                        dataSelecionada = dataEscolhida;
                        dataController.text = "${dataEscolhida.day}/${dataEscolhida.month}/${dataEscolhida.year}";
                      });
                    }
                  },
                ),
            
                SizedBox(height: 12,),
            
                Text("Categoria da Despesa", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
            
                SizedBox(height: 12,),
            
                DropdownButtonFormField<String>(
                  initialValue: categoriaSelecionada,
                  decoration: InputDecoration(
                  hintText: "Selecione a Categoria",
                  border: OutlineInputBorder(),
                  ),
                    items: [
                      DropdownMenuItem(value: "Alimentação", child: Text("Alimentação")),
                      DropdownMenuItem(value: "Transporte", child: Text("Transporte")),
                      DropdownMenuItem(value: "Moradia", child: Text("Moradia")),
                      DropdownMenuItem(value: "Saúde", child: Text("Saúde")),
                      DropdownMenuItem(value: "Educação", child: Text("Educação")),
                      DropdownMenuItem(value: "Lazer", child: Text("Lazer")),
                      DropdownMenuItem(value: "Outros", child: Text("Outros")),
                    ],
                      onChanged: (valor) {
                        setState(() {
                          categoriaSelecionada = valor;
                          });
                        },
                      ),
            
                SizedBox(height: 12,),
            
                Text("Anexar Comprovante", 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
            
                SizedBox(height: 12),
            
                ElevatedButton(
                  onPressed: () async {
                    await FilePicker.platform.pickFiles();
                  },
                  child: Text("Escolher Arquivo"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Fechar"),
            ),
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
              },
              child: Text("Cadastrar"),
            ),
          ],
        );
      },
    );
  }
}