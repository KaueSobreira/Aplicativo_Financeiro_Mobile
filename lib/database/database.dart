import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("despesas.db");
    return _database!;
  }

  Future<Database> _initDB(String filename) async {
    final caminho = await getDatabasesPath();
    final path = join(caminho, filename);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _criarTabelas,
    );
  }

  Future _criarTabelas(Database db, int version) async {
    await db.execute('''
      CREATE TABLE despesas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT,
        valor REAL,
        dataVencimento TEXT,
        categoria TEXT,
        comprovante TEXT  -- Nome corrigido para bater com o model
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}