import 'package:sqflite/sqflite.dart';
import '../models/despesa.dart';
import 'database.dart';

class DespesaDAO {
  Future<int> inserir(Despesa despesa) async {
    final db = await AppDatabase.instance.database;
    return await db.insert("despesas", despesa.toMap());
  }

  Future<List<Despesa>> listar() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query("despesas", orderBy: "id DESC");
    return result.map((e) => Despesa.fromMap(e)).toList();
  }

  Future<int> atualizar(Despesa despesa) async {
    final db = await AppDatabase.instance.database;
    return await db.update(
      "despesas",
      despesa.toMap(),
      where: "id = ?",
      whereArgs: [despesa.id],
    );
  }

  Future<int> excluir(int id) async {
    final db = await AppDatabase.instance.database;
    return await db.delete(
      "despesas",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
