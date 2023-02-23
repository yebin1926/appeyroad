import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:team2todolist/todolist.dart';

final String tableName = "TodolistforTest";

class DBHelper {
  //DBHelper._();
  //static final DBHelper _db = DBHelper._();
  //factory DBHelper() => _db;

  Database? _database;
  int id = 0;
  Future<Database> get database async {
    if(_database != null) return _database!;

    return await initDB();
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'Todolist.db');
    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY,
            date TEXT NOT NULL,
            name TEXT NOT NULL,
            note TEXT,
            color INTEGER
          )
        ''');
        },
        onUpgrade: (db, oldVersion, newVersion){}
    );
  }
  Future<void> getID() async {
    final db = await database;
    var x = await db.rawQuery('SELECT MAX(id) FROM $tableName');
    int count = Sqflite.firstIntValue(x)!;
    print(count);
    id = count;
  }
  Future<List<TodolistInfo>> getDB() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(tableName);
    if( maps.isEmpty ) return [];
    List<TodolistInfo> list = List.generate(maps.length, (index) {
      return TodolistInfo(
        maps[index]["id"],
        maps[index]["date"],
        maps[index]["name"],
        maps[index]["note"] ?? "",
        maps[index]["color"] ?? 0,
      );
    });
    return list;
  }
  Future<List<TodolistInfo>> getQuery(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.rawQuery(query);
    if( maps.isEmpty ) return [];
    List<TodolistInfo> list = List.generate(maps.length, (index) {
      return TodolistInfo(
        maps[index]["id"],
        maps[index]["date"],
        maps[index]["name"],
        maps[index]["note"] ?? "",
        maps[index]["color"] ?? 0,
      );
    });
    return list;
  }
  Future<List<TodolistInfo>> getQueryFromDate(DateTime dateSet) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.rawQuery("SELECT * FROM $tableName WHERE date = '" + getDateString(dateSet) + "'");
    if( maps.isEmpty ) return [];
    List<TodolistInfo> list = List.generate(maps.length, (index) {
      return TodolistInfo(
        maps[index]["id"],
        maps[index]["date"],
        maps[index]["name"],
        maps[index]["note"] ?? "",
        maps[index]["color"] ?? 0,
      );
    });
    return list;
  }
  Future<void> insert(TodolistInfo todolistInfo) async {
    final db = await database;
    await db?.insert(tableName, todolistInfo.toMap());
  }
  Future<void> update(TodolistInfo todolistInfo) async {
    final db = await database;
    await db?.update(
      tableName,
      todolistInfo.toMap(),
      where: "id = ?",
      whereArgs: [todolistInfo.id],
    );
  }
  Future<void> delete(int id) async {
    final db = await database;
    await db?.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }
  Future<void> updateFromDate(TodolistInfo todolistInfo) async {
    final db = await database;
    await db?.update(
      tableName,
      todolistInfo.toMap(),
      where: "date = ?",
      whereArgs: [todolistInfo.date],
    );
  }
  Future<void> deleteFromDate(TodolistInfo todolistInfo) async {
    final db = await database;
    await db?.delete(
      tableName,
      where: "date = ?",
      whereArgs: [todolistInfo.date],
    );
  }
  /*
  //Create
  createData(TodolistInfo todolist) async {
    final db = await database;
    var res = await db.rawInsert('INSERT INTO $tableName(name) VALUES(?)', [todolist.name]);
    return res;
  }
  //Read
  getDog(int id) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName WHERE id = ?', [id]);
    return res.isNotEmpty ? Dog(id: res.first['id'], name: res.first['name']) : Null;
  }

  //Read All
  Future<List<TodolistInfo>> getAllDogs() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName');
    List<Dog> list = res.isNotEmpty ? res.map((c) => Dog(id:c['id'], name:c['name'])).toList() : [];

    return list;
  }

  //Delete
  deleteDog(int id) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $TableName WHERE id = ?', [id]);
    return res;
  }

  //Delete All
  deleteAllDogs() async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName');
  }
*/
}