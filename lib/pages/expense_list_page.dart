import 'dart:io';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart'; 
import '../widgets/resumo_card.dart';
import '../dialogs/dialog_cadastro_despesa.dart';
import '../database/despesa_dao.dart';
import '../models/despesa.dart';
import 'despesa_detalhe_page.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  String? tipoFiltroSelecionado;
  DateTime? dataFiltragem;
  String? categoriaFiltroSelecionada;

  final TextEditingController dataControllerFiltragem = TextEditingController();
  
  List<Despesa> _todasDespesas = [];
  List<Despesa> _listaExibida = [];
  final DespesaDAO _dao = DespesaDAO();
  double _totalExibido = 0.0;

  final _formatadorMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final _formatadorData = DateFormat('dd/MM/yyyy');
  final _formatadorMes = DateFormat('MMMM / yyyy', 'pt_BR'); 

  final List<String> _categorias = [
    "Alimentação", "Transporte", "Moradia", "Saúde", "Educação", "Lazer", "Outros"
  ];

  @override
  void initState() {
    super.initState();
    _buscarDadosDoBanco();
  }

  Future<void> _buscarDadosDoBanco() async {
    final lista = await _dao.listar();
    setState(() {
      _todasDespesas = lista;
      _aplicarFiltros();
    });
  }

  void _aplicarFiltros() {
    List<Despesa> temp = List.from(_todasDespesas);

    if (tipoFiltroSelecionado == "Por Mês" && dataFiltragem != null) {
      temp = temp.where((d) {
        try {
          final dataDespesa = _formatadorData.parse(d.dataVencimento);
          
          return dataDespesa.month == dataFiltragem!.month && 
                 dataDespesa.year == dataFiltragem!.year;
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (tipoFiltroSelecionado == "Por Categoria" && categoriaFiltroSelecionada != null) {
      temp = temp.where((d) => d.categoria == categoriaFiltroSelecionada).toList();
    }

    double soma = 0;
    for (var d in temp) {
      soma += d.valor;
    }

    setState(() {
      _listaExibida = temp;
      _totalExibido = soma;
    });
  }

  @override
  void dispose() {
    dataControllerFiltragem.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Center(child: Text("Lista de Despesas"))),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await mostrarDialogCadastro(context);
          _buscarDadosDoBanco();
        },
        child: const Icon(Icons.add, size: 40, color: Colors.blue),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Selecione o Tipo de Filtro", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            DropdownButtonFormField<String>(
              initialValue: tipoFiltroSelecionado,
              decoration: const InputDecoration(labelText: "Tipo de Filtro", border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: "Todos", child: Text("Todos")),
                DropdownMenuItem(value: "Por Mês", child: Text("Por Mês")),
                DropdownMenuItem(value: "Por Categoria", child: Text("Por Categoria")),
              ],
              onChanged: (valor) {
                setState(() {
                  tipoFiltroSelecionado = valor;
                  dataControllerFiltragem.clear();
                  dataFiltragem = null;
                  categoriaFiltroSelecionada = null;
                  _aplicarFiltros();
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
                      dataFiltragem = mesSelecionado;
                      dataControllerFiltragem.text = _formatadorMes.format(mesSelecionado).toUpperCase();
                      _aplicarFiltros();
                    });
                  }
                },
              )
            else if (tipoFiltroSelecionado == "Por Categoria")
              DropdownButtonFormField<String>(
                initialValue: categoriaFiltroSelecionada,
                decoration: const InputDecoration(
                  labelText: "Selecione a Categoria",
                  border: OutlineInputBorder(),
                ),
                items: _categorias.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (valor) {
                  setState(() {
                    categoriaFiltroSelecionada = valor;
                    _aplicarFiltros();
                  });
                },
              ),

            const SizedBox(height: 30),

            ResumoCard(
              titulo: "Total Filtrado",
              valor: _formatadorMoeda.format(_totalExibido),
              corValor: Colors.red,
            ),
            
            const SizedBox(height: 10),

            Card(
              color: Colors.black87,
              child: Container(
                width: double.infinity,
                height: 400,
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                     const Text(
                      'Listagem de Despesas',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    
                    Expanded(
                      child: _listaExibida.isEmpty 
                      ? const Center(child: Text("Nenhuma despesa encontrada", style: TextStyle(color: Colors.white70)))
                      : ListView.separated(
                          itemCount: _listaExibida.length,
                          separatorBuilder: (_, __) => const Divider(color: Colors.white24),
                          itemBuilder: (context, index) {
                            final despesa = _listaExibida[index];
                            
                            Widget iconeOuFoto;
                            if (despesa.comprovante != null && despesa.comprovante!.isNotEmpty) {
                              iconeOuFoto = CircleAvatar(
                                radius: 25,
                                backgroundImage: FileImage(File(despesa.comprovante!)),
                                onBackgroundImageError: (_,__) {},
                              );
                            } else {
                              iconeOuFoto = CircleAvatar(
                                backgroundColor: Colors.blueGrey,
                                child: Icon(_getIconeCategoria(despesa.categoria), color: Colors.white),
                              );
                            }

                            return ListTile(
                              leading: iconeOuFoto,
                              title: Text(
                                despesa.descricao,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${despesa.categoria} - ${despesa.dataVencimento}",
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DespesaDetalhePage(despesa: despesa),
                                  ),
                                );
                                _buscarDadosDoBanco();
                              },
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
}