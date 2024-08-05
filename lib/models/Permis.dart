import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pp/models/Projets.dart';


class Permis {
  static Database? _db;
  static final Permis instance = Permis._constructor();
  final String _tableName = "permis";
  final String _columnId = "idpermis";
  final String _columnDebut = "datedebut";
  final String _columnFin = "datefin";
  final String _columnStatus = "status";
  final String _columnLieu = "lieu";
  final String _columnIdprojet = "idprojet";


  Permis._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _getDatabase();
    return _db!;
  }

  Future<Database> _getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "permis.db");

    final database = await openDatabase(
      databasePath,
      onCreate: (db, version) async {
        try {
          await db.execute("""
          CREATE TABLE $_tableName (
            $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_columnDebut TEXT NOT NULL,
            $_columnFin TEXT NOT NULL,
            $_columnStatus TEXT NOT NULL,
            $_columnLieu TEXT NOT NULL,
            $_columnIdprojet INTEGER NOT NULL,
            FOREIGN KEY ($_columnIdprojet) REFERENCES ${Projets.instance.tableName}(${Projets.instance.columnId})          )
        """);
        } catch (e) {
          print('Error creating table: $e');
        }
      },
      version: 1,
    );

    return database;
  }



  Future<void> insertPermis(
      String datedebut,
      String datefin,
      String status,
      String lieu,
      int idprojet,) async {
    final db = await database;
    await db.insert(
      _tableName,
      {
        _columnDebut: datedebut,
        _columnFin: datefin,
        _columnStatus: status,
        _columnLieu: lieu,
        _columnIdprojet: idprojet,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllPermis() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return maps;
  }
  Future<void> deletePermis(int id) async {
    final db = await _getDatabase();
    await db.delete(
      'permis',
      where: 'idpermis = ?',
      whereArgs: [id],
    );
  }
  Future<List<Map<String, dynamic>>> getPermisByProjectId(int idprojet) async {
    final db = await _getDatabase();
    return await db.query(
      _tableName,
      where: '$_columnIdprojet = ?',
      whereArgs: [idprojet],
    );
  }

  Future<void> updatePermis(
      int idpermis,
      String datedebut,
      String datefin,
      String status,
      String lieu,
      int idprojet,) async {
    final db = await _getDatabase();
    await db.update(
      _tableName,
      {
        _columnDebut: datedebut,
        _columnFin: datefin,
        _columnStatus: status,
        _columnLieu: lieu,
        _columnIdprojet: idprojet,
      },
      where: '$_columnId = ?',
      whereArgs: [idpermis],
    );
  }
}
