
import 'package:calendar_flutter_app/src/data/data.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class SqlfliteProvider with ChangeNotifier {
  List<Date> dateList = List<Date>(372);
  Database dateDB;

  SqlfliteProvider() {
    logger.d('init SqlfliteProvider');
    _loadDatabase();
  }

  void setDate(int index, Date date) {
    dateList[index] = date;
    notifyListeners();
  }

  Date getDate(int index) {
    return dateList[index];
  }

  List<Date> getDateList() {
    return dateList;
  }

  void resetDateList() {
    dateList = List<Date>(372);
  }

  Future<void> _loadDatabase() async {
    _openDatabase().then((_) async {
      var savedList = await getDates();
      for(var date in savedList) {
        var index = getDaysFromYear(date.month, date.day);
        dateList[index] = date;
      }

      notifyListeners();
    });
  }

  Future<List<Date>> getDates() async {
    final List<Map<String, dynamic>> maps = await dateDB?.query('dates');
    if(maps == null) return null;
    return List.generate(maps.length, (i){
      return Date(
        month: maps[i]['month'],
        day: maps[i]['day'],
        feeling: maps[i]['feeling'],
        message: maps[i]['message'],
        icon: maps[i]['icon'],
      );
    });
  }

  Future<void> _openDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'dates.db');
    //await deleteDatabase(path);
    dateDB = await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE dates(id TEXT PRIMARY KEY, month INTEGER, day INTEGER, feeling TEXT, message TEXT, icon TEXT'
        );
      },
      version: 1,
    );
  }

  Future<void> backUpDatabase(List<Date> loadList) async {
    await dateDB.delete('dates');
    for(var date in loadList) {
      await dateDB.insert('dates', date.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    resetDateList();
    var savedList = await getDates();
    print(savedList);
    for(var date in savedList) {
      var index = getDaysFromYear(date.month, date.day);
      dateList[index] = date;
    }
    print(dateList);
    notifyListeners();
  }

  Future<void> insertDate(Date date) async {
    await dateDB?.insert(
      'dates',
      date.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> updateDate(Date date) async {
    await dateDB?.update('dates',
      date.toJson(),
      where: 'id = ?', whereArgs: ['2020-${date.month}-${date.day}']
    );
  }

  Future<void> deleteDate(Date date) async {
    await dateDB?.delete('dates',
      where: 'id = ?', whereArgs: ['2020-${date.month}-${date.day}']
    );
  }

}