class Despesa {
  int? id;
  String descricao;
  double valor;
  String dataVencimento;
  String categoria;
  String? comprovante; // <-- ADICIONAR

  Despesa({
    this.id,
    required this.descricao,
    required this.valor,
    required this.dataVencimento,
    required this.categoria,
    this.comprovante,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'valor': valor,
      'dataVencimento': dataVencimento,
      'categoria': categoria,
      'comprovante': comprovante, // <-- ADICIONAR
    };
  }

  factory Despesa.fromMap(Map<String, dynamic> map) {
    return Despesa(
      id: map['id'],
      descricao: map['descricao'],
      valor: map['valor'],
      dataVencimento: map['dataVencimento'],
      categoria: map['categoria'],
      comprovante: map['comprovante'], // <-- ADICIONAR
    );
  }
}
