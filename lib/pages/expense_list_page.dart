import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../widgets/resumo_card.dart';
import '../dialogs/dialog_cadastro_despesa.dart';
import '../database/despesa_dao.dart';
import '../models/despesa.dart';

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
  
  // Variáveis para armazenar dados do banco
  List<Despesa> _listaDespesas = [];
  final DespesaDAO _dao = DespesaDAO();
  double _totalDespesas = 0.0;

  @override
  void initState() {
    super.initState();
    _atualizarDados(); // Carrega os dados ao iniciar
  }

  // Função que busca no banco e atualiza a tela
  Future<void> _atualizarDados() async {
    final lista = await _dao.listar();
    
    // Lógica simples de soma para o card de resumo
    double soma = 0;
    for (var d in lista) {
      soma += d.valor;
    }

    setState(() {
      _listaDespesas = lista;
      _totalDespesas = soma;
    });
  }

  @override
  void dispose() {
    dataControllerFiltragem.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  String _mesNome(int mes) {
    const nomes = ["", "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"];
    return nomes[mes];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Center(child: Text("Lista de Despesas"))),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // O 'await' aqui espera o dialog fechar antes de continuar
          await mostrarDialogCadastro(context);
          // Quando fecha, atualiza a lista
          _atualizarDados();
        },
        child: const Icon(Icons.add, size: 40, color: Colors.blue),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... Seção de Filtros (mantida igual) ...
            const Text("Selecione o Tipo de Filtro", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: tipoFiltroSelecionado,
              decoration: const InputDecoration(labelText: "Tipo de Filtro", border: OutlineInputBorder()),
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
                decoration: const InputDecoration(labelText: "Selecione o Mês", border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)),
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
                      dataControllerFiltragem.text = "${_mesNome(mesSelecionado.month)} / ${mesSelecionado.year}";
                    });
                  }
                },
              )
            else if (tipoFiltroSelecionado == "Por Categoria")
              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(labelText: "Descrição da Categoria", border: OutlineInputBorder()),
              ),
            const SizedBox(height: 30),

            // CARDS DE RESUMO (DADOS REAIS)
            ResumoCard(
              titulo: "Total Geral",
              valor: "R\$ ${_totalDespesas.toStringAsFixed(2)}", // Valor dinâmico
              corValor: Colors.red,
            ),
            
            // Mantive os outros cards estáticos por enquanto
            const ResumoCard(
              titulo: "Total Despesas já pagas",
              valor: "0,00",
              corValor: Colors.green,
            ),

            const SizedBox(height: 10),

            // LISTA DE DESPESAS
            Card(
              color: Colors.black87,
              child: Container(
                width: double.infinity,
                height: 400, // Aumentei um pouco
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                     const Text(
                      'Listagem de Despesas',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    
                    // AQUI ESTÁ A LISTVIEW REAL
                    Expanded(
                      child: _listaDespesas.isEmpty 
                      ? const Center(child: Text("Nenhuma despesa cadastrada", style: TextStyle(color: Colors.white70)))
                      : ListView.separated(
                          itemCount: _listaDespesas.length,
                          separatorBuilder: (_, __) => const Divider(color: Colors.white24),
                          itemBuilder: (context, index) {
                            final despesa = _listaDespesas[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueGrey,
                                child: Icon(_getIconeCategoria(despesa.categoria), color: Colors.white),
                              ),
                              title: Text(
                                despesa.descricao,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${despesa.categoria} - Vence: ${despesa.dataVencimento}",
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing: Text(
                                "R\$ ${despesa.valor.toStringAsFixed(2)}",
                                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            );
                          },
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

  // Função auxiliar para ícones
  IconData _getIconeCategoria(String categoria) {
    switch (categoria) {
      case "Alimentação": return Icons.restaurant;
      case "Transporte": return Icons.directions_car;
      case "Moradia": return Icons.home;
      case "Saúde": return Icons.local_hospital;
      case "Educação": return Icons.school;
      case "Lazer": return Icons.beach_access;
      default: return Icons.attach_money;
    }
  }
}