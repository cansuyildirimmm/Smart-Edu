import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

class DbManager {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'materials.db');

    if (!await File(path).exists()) {
      final data = await rootBundle.load('assets/materials/materials.db');
      final bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path);
  }

  static Future<List<Map<String, dynamic>>> getAllMaterials() async {
    final db = await database;
    return await db.query('materials');
  }

  static Future<List<Map<String, dynamic>>> getMaterialsFiltered({
    required String learningStyle,
    required String disability,
    required String topicName,
  }) async {
    final db = await database;
    return await db.query(
      'materials',
      where: 'learning_style = ? AND disability = ? AND topic = ?',
      whereArgs: [learningStyle, disability, topicName],
    );
  }
}