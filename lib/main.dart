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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Nova Despesa"),
          content: Text("Aqui vamos colocar os campos"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Fechar"),
            ),
          ],
        );
      },
    );
  }
}