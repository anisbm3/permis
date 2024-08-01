import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pp/database_helper.dart';

class Projets {
  static Database? _db;
  static final Projets instance = Projets._constructor();
  final String _tableName = "projet";
  final String _columnId = "idprojet";
  final String _columnCode = "code";
  final String _columnDebut = "datedebut";
  final String _columnFin = "datefin";
  final String _columnDesignation = "designation";
  final String _columnStatus = "status";
  final String _columnResponsable = "responsable";
  final String _columnDescription = "description";
  final String _columnLieu = "lieu";
  final String _columnPdf = "pdf";


  Projets._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _getDatabase();
    return _db!;
  }

  Future<Database> _getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "projet.db");

    final database = await openDatabase(
      databasePath,
      onCreate: (db, version) {
        try {
          db.execute('''
          CREATE TABLE $_tableName (
            $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_columnCode TEXT NOT NULL,
            $_columnDebut TEXT NOT NULL,
            $_columnFin TEXT NOT NULL,
            $_columnDesignation TEXT NOT NULL,
            $_columnStatus TEXT NOT NULL,
            $_columnResponsable TEXT NOT NULL,
            $_columnDescription TEXT NOT NULL,
            $_columnLieu TEXT NOT NULL,
            $_columnPdf TEXT
          )
        ''');
        } catch (e) {
          print('Error creating table: $e');
        }
      },
      version: 1,
    );

    return database;
  }


  Future<void> insertProjet(String code,
      DateTime datedebut,
      DateTime datefin,
      String designation,
      String status,
      String responsable,
      String description,
      String lieu,
      String pdfPath,) async {
    final db = await database;
    await db.insert(
      _tableName,
      {
        _columnCode: code,
        _columnDebut: datedebut.millisecondsSinceEpoch,
        _columnFin: datefin.millisecondsSinceEpoch,
        _columnDesignation: designation,
        _columnStatus: status,
        _columnResponsable: responsable,
        _columnDescription: description,
        _columnLieu: lieu,
        _columnPdf: pdfPath,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllProjects() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return maps;
  }

  Future<void> deleteProjets(int id) async {
    final db = await _getDatabase();
    await db.delete(
      'projet',
      where: 'idprojet = ?',
      whereArgs: [id],
    );
  }
}
