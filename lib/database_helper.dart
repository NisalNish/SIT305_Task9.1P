import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('adverts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE adverts ( 
  id $idType, 
  name $textType,
  phone $textType,
  description $textType,
  location $textType,
  date $textType,
  postType $textType
  )
''');
  }

  Future<int> addAdvert(Map<String, dynamic> advert) async {
    final db = await instance.database;
    return await db.insert('adverts', advert);
  }

  Future<List<Map<String, dynamic>>> getLostProjects() async {
    final db = await instance.database;
    return await db.query('adverts', where: 'postType = ?', whereArgs: ['Lost']);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await instance.database;
    return await db.query('adverts');
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('adverts', where: 'id = ?', whereArgs: [id]);
  }
}
