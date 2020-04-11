// System Packages
import 'dart:async';
import 'dart:io' show Directory;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
//Models
import 'package:compete_viewer/models/contestant_model.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    if (_database.isOpen) {
      print("Database successfully opened: " + _database.path);
    }
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "compete_viewer_data.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (database, version) async {
        Batch batch = database.batch();
        batch.execute("CREATE TABLE IF NOT EXISTS contestants ("
            "contnumber INTEGER PRIMARY KEY,"
            "contname TEXT,"
            "fblikes INTEGER,"
            "fbcomments INTEGER,"
            "fbshares INTEGER,"
            "instalikes INTEGER,"
            "instacomments INTEGER,"
            "adjfbcomments INTEGER,"
            "adjfbshares INTEGER,"
            "adjinstacomments INTEGER,"
            "totalpoints INTEGER,"
            "lastupdated TEXT"
            ")");
        return await batch.commit();
      },
    );
  }

  newContestant(Contestant newCont) async {
    final db = await database;
    int res = await db.insert("contestants", newCont.toMap());
    return res;
  }

  Future<List<Contestant>> getAllContestants() async {
    final db = await database;
    var res = await db.query("contestants");
    List<Contestant> list = res.isNotEmpty ? res.map((c) => Contestant.fromMap(c)).toList():[];
    return list;
  }

  updateContestants(List<Contestant> contestantList) async {
    final db = await database;

    contestantList.forEach((contestant) async {
      await db.update("contestants", contestant.toMap(), 
                      where: "contnumber = ?", 
                      whereArgs: [contestant.contNumber]);
    });
  }

  deleteContestants(List<Contestant> contestantList) async {
    final db = await database;

     contestantList.forEach((contestant) async {
      await db.delete("contestants", 
                      where: "contnumber = ?", 
                      whereArgs: [contestant.contNumber]);
    });
  }

  Future<bool> contestantExist({int contNumber, String contName}) async {
    final db = await database;
    final List<Map<String,dynamic>> queryResult = await db.rawQuery(
                          "SELECT * FROM contestants WHERE contnumber = ? AND contname = ?", [contNumber,contName]);
    return queryResult.length!=0?true:false;
  }

  deleteTables() async {
      final db = await database;
      await db.delete("contestants");
  }
}