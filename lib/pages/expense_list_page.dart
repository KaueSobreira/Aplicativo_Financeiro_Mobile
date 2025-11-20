import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../widgets/resumo_card.dart';
import '../dialogs/dialog_cadastro_despesa.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  String? tipoFiltroSelecionado;
  DateTime? dataFiltagem;

  final TextEditingController dataControllerFiltragem = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  @override
  void dispose() {
    dataControllerFiltragem.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  String _mesNome(int mes) {
    const nomes = [
      "", "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
      "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
    ];
    return nomes[mes];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Center(child: Text("Lista de Despesas")),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mostrarDialogCadastro(context);
        },
        child: const Icon(Icons.add, size: 40, color: Colors.blue),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Selecione o Tipo de Filtro",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: tipoFiltroSelecionado,
              decoration: const InputDecoration(
                labelText: "Tipo de Filtro",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Por Mês", child: Text("Por Mês")),
                DropdownMenuItem(value: "Por Categoria", child: Text("Por Categoria")),
              ],
              onChanged: (valor) {
                setState(() {
                  tipoFiltroSelecionado = valor;
                  dataControllerFiltragem.clear();
                  descricaoController.clear();
                });
              },
            ),

            const SizedBox(height: 20),

            if (tipoFiltroSelecionado == "Por Mês")
              TextField(
                controller: dataControllerFiltragem,
                decoration: const InputDecoration(
                  labelText: "Selecione o Mês",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime now = DateTime.now();

                  final mesSelecionado = await showMonthPicker(
                    context: context,
                    initialDate: now,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (mesSelecionado != null) {
                    setState(() {
                      dataFiltagem = mesSelecionado;
                      dataControllerFiltragem.text =
                          "${_mesNome(mesSelecionado.month)} / ${mesSelecionado.year}";
                    });
                  }
                },
              )

            else if (tipoFiltroSelecionado == "Por Categoria")
              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(
                  labelText: "Descrição da Categoria",
                  border: OutlineInputBorder(),
                ),
              ),

            const SizedBox(height: 30),

            const ResumoCard(
              titulo: "Total Despesas em Aberto",
              valor: "10.000,00",
              corValor: Colors.red,
            ),

            const ResumoCard(
              titulo: "Total Despesas já pagas",
              valor: "5.000,00",
              corValor: Colors.green,
            ),

            const ResumoCard(
              titulo: "Categoria com mais Gastos",
              valor: "Alimentação",
              corValor: Colors.white,
            ),

            const ResumoCard(
              titulo: "Total Despesas do Próximo Mês",
              valor: "35.000,00",
              corValor: Colors.white,
            ),

            const SizedBox(height: 10),

            Card(
              color: Colors.black87,
              child: Container(
                width: double.infinity,
                height: 350,
                padding: const EdgeInsets.all(16),
                child: const Column(
                  children: [
                    Text(
                      'Listagem de Despesas',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Aqui vai ser a ListView',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
