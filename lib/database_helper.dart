import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  static const String usersTable = 'users';
  static const String columnUserId = 'id';
  static const String columnEmail = 'email';
  static const String columnPassword = 'password';

  DatabaseHelper._internal();

  static DatabaseHelper get instance => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $usersTable(
            $columnUserId INTEGER PRIMARY KEY, 
            $columnEmail TEXT, 
            $columnPassword TEXT
          )
          ''',
        );
      },
    );
  }

  Future<void> insertUser(String email, String password) async {
    final db = await database;

    await db.insert(
      usersTable,
      {'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      usersTable,
      where: '$columnEmail = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }
  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      usersTable,
      where: '$columnUserId = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }
}
