import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: ExpenseListPage(),
  //   );
  // }

  Widget build(BuildContext context) => Scaffold(
    appBar: taskAppBar(),
    floatingActionButton: taskAppFloatingActionButton(),
    body: ExpenseListPage(),
  );
}

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  String? tipoFiltroSelecionado;
  DateTime? dataFiltagem;
  final TextEditingController dataControllerFiltragem = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Text("Selecione o Tipo de Filtro"),
            DropdownButtonFormField<String>(
              initialValue: tipoFiltroSelecionado,
              decoration: InputDecoration(
              hintText: "Tipo de Filtro",
              border: OutlineInputBorder(),
              ),
                items: [
                  DropdownMenuItem(value: "Por Mês", child: Text("Por Mês")),
                  DropdownMenuItem(value: "Por Categoria", child: Text("Por Categoria")),
                ],
                  onChanged: (valor) {
                    setState(() {
                      tipoFiltroSelecionado = valor;
                    });
                  },
                ),
              ],
            ),
            tipoFiltroSelecionado == "Por Mês"
              ? TextField(
                  controller: dataControllerFiltragem,
                  decoration: const InputDecoration(hintText: "Selecione a Data"),
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
                        dataFiltagem = dataEscolhida;
                        dataControllerFiltragem.text =
                            "${dataEscolhida.day}/${dataEscolhida.month}/${dataEscolhida.year}";
                      });
                    }
                  },
                )
              : TextField(
                  decoration: InputDecoration(hintText: "Descrição"),
                ),
            Card(
              color: Colors.black,  // Margem externa
              child: Container(         
                constraints: BoxConstraints(
                  minWidth: 1000,
                ),    // Precisa de um child para mostrar conteúdo
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Total Despesas em Aberto', 
                       style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                        ),
                    ),
                    Text(
                      '10.000,00', 
                       style: TextStyle(
                        color: Colors.red, 
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                        ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.black,  // Margem externa
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 1000,
                ),             // Precisa de um child para mostrar conteúdo
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Total Despesas já pagas', 
                       style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    ),
                    Text(
                      '5.000,00', 
                       style: TextStyle(
                        color: Colors.green, 
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                        ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.black,  // Margem externa
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 1000,
                ),             // Precisa de um child para mostrar conteúdo
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Categoria com mais Gastos', 
                       style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    ),
                    Text(
                      'Alimentação', 
                       style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                        ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.black,  // Margem externa
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 1000,
                ),             // Precisa de um child para mostrar conteúdo
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Total Despesas do Próximo Mês', 
                       style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    ),
                    Text(
                      '35.000,00', 
                       style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                        ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.black,  // Margem externa
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 1000,
                  minHeight: 350,
                ),             // Precisa de um child para mostrar conteúdo
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Listagem de Despesas', 
                       style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    ),
                    Text(
                      'Aqui vai ser a List View', 
                       style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                        ),
                    ),
                  ],
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     // mostrarDialogCadastro();
            //   },
            //   child: Icon(Icons.add, size: 40, color: Colors.blue,),
            // ),
          ],
        ),
      ),
    );
  }
  // Método que mostra o dialog de cadastr
}

AppBar taskAppBar() => AppBar(title: Center(child: Text("Lista de Despesas")));

  FloatingActionButton taskAppFloatingActionButton() => FloatingActionButton(
    onPressed: mostrarDialogCadastro(),
    child: Icon(Icons.add, size: 40, color: Colors.blue,),
  );

mostrarDialogCadastro() {
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