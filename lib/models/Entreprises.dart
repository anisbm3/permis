import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pp/database_helper.dart';

class Entreprise {
  static Database? _db;
  static final Entreprise instance = Entreprise._constructor();
  final String _tableName = "entreprise";
  final String _columnId = "identreprise";
  final String _columnName = "nom";
  final String _columnRaisonSocial = "raisonsocial";
  final String _columnAddress = "adress";
  final String _columnTel = "tel";
  final String _columnIdUser = "iduser";

  Entreprise._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _getDatabase();
    return _db!;
  }

  Future<Database> _getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "entreprise.db");
    final database = await openDatabase(
      databasePath,
      onCreate: (db, version) {
        try {
          db.execute('''
          CREATE TABLE $_tableName(
            $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_columnName TEXT NOT NULL,
            $_columnRaisonSocial TEXT NOT NULL,
            $_columnAddress TEXT NOT NULL,
            $_columnTel TEXT NOT NULL,
            $_columnIdUser INTEGER NOT NULL,
            FOREIGN KEY ($_columnIdUser) REFERENCES ${DatabaseHelper.usersTable}(${DatabaseHelper.columnUserId})
          
        ''');
        } catch (e) {
          print('Error creating table: $e');
        }
      },
      version: 1,
    );
    return database;
  }


  Future<void> insertEntreprise(String nom, String raisonSocial, String address, String telephone, int idUser) async {
    final db = await database;

    await db.insert(
      _tableName,
      {
        _columnName: nom,
        _columnRaisonSocial: raisonSocial,
        _columnAddress: address,
        _columnTel: telephone,
        _columnIdUser: idUser,
      },
    );
  }
  Future<List<Map<String, dynamic>>> getAllCompanies() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return maps;
  }
  Future<List<int>> getUserIds() async {
    final db = await _getDatabase();
    final result = await db.query('users', columns: ['id']);
    return result.map((e) => e['id'] as int).toList();
  }
  Future<void> deleteEntreprise(int id) async {
    final db = await _getDatabase();
    await db.delete(
      'entreprise',
      where: 'identreprise = ?',
      whereArgs: [id],
    );
  }
  Future<void> updateEntreprise(int id, String nom, String raisonSocial, String address, String telephone, int idUser) async {
    final db = await _getDatabase();
    await db.update(
      _tableName,
      {
        _columnName: nom,
        _columnRaisonSocial: raisonSocial,
        _columnAddress: address,
        _columnTel: telephone,
        _columnIdUser: idUser,
      },
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }
}
