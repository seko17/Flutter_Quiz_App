import 'package:param_quiz_app/models/result.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class ResultsDB {
  static final ResultsDB instance = ResultsDB._init();

  static Database _database;

  ResultsDB._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('results.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableResult ( 
  ${ResultField.id} $idType, 
  ${ResultField.category} $textType,
  ${ResultField.score} $textType,
  ${ResultField.time} $textType
  )
''');
  }

  Future<Result> create(Result res) async {
    final db = await instance.database;

    final id = await db.insert(tableResult, res.toJson());
    return res.copy(id: id);
  }

  Future<List<Result>> readAll() async {
    final db = await instance.database;

    final orderBy = '${ResultField.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableResult, orderBy: orderBy);

    return result.map((json) => Result.fromJson(json)).toList();
  }


  Future close() async {
    final db = await instance.database;

    db.close();
  }
}