import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sportify_app/database/field_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInstance {
  final String _databaseName = 'my_database.db';
  final int _databaseversion = 3;

  final String table = 'field';
  final String id = 'id';
  final String name = 'name';
  final String activity = 'activity';
  final String location = 'location';
  final String createdAt = 'createdAt';
  final String updatedAt = 'updatedAt';

  Database? _database;

  Future<Database> database() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future _initDatabase() async {
    Directory documenDirectory = await getApplicationDocumentsDirectory();
    String path = join(documenDirectory.path, _databaseName);
    return openDatabase(
      path,
      version: _databaseversion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $table ('
      '$id INTEGER PRIMARY KEY, '
      '$name TEXT, '
      '$activity TEXT, '
      '$location TEXT, '
      '$createdAt TEXT, '
      '$updatedAt TEXT'
      ')',
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE field ADD COLUMN createdAt TEXT');
      await db.execute('ALTER TABLE field ADD COLUMN updatedAt TEXT');
    }
    if (oldVersion < 3) {
      await db.execute(
          'CREATE TEMPORARY TABLE backup(id, name, activity, location, createdAt, updatedAt)');
      await db.execute(
          'INSERT INTO backup SELECT id, name, activity, location, createdAt, updatedAt FROM field');
      await db.execute('DROP TABLE field');
      await db.execute('CREATE TABLE field ('
          'id INTEGER PRIMARY KEY, '
          'name TEXT, '
          'activity TEXT, '
          'location TEXT, '
          'createdAt TEXT, '
          'updatedAt TEXT'
          ')');
      await db.execute(
          'INSERT INTO field SELECT id, name, activity, location, createdAt, updatedAt FROM backup');
      await db.execute('DROP TABLE backup');
    }
  }

  Future<List<FieldModel>> all() async {
    final db = await database();
    final data = await db.query(table);
    List<FieldModel> result = data.map((e) => FieldModel.fromJson(e)).toList();
    return result;
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final db = await database();
    return await db.insert(table, row);
  }

  Future<int> update(int id, Map<String, dynamic> row) async {
    final db = await database();
    return await db.update(
      table,
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database();
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
