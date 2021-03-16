import 'package:sqflite/sqflite.dart';

final String tableName = "alarm";
final String columnId = 'id';
final String columnTitle = 'title';

class DBHelper {
  static Database _database;
  // static DBHelper _dbHelper;
  //
  // DBHelper._createInstance();
  //
  // factory DBHelper() {
  //   if (_dbHelper == null) {
  //     _dbHelper = DBHelper()._createInstance();
  //   }
  //   return _dbHelper;
  // }

  Future<Database> get database async {
    if (_database == null ) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "test.db";

    openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $tableName ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null)
        ''');
      },
    );
    return database;
  }
}