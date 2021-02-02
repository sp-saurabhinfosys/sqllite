import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper{

  static final String dbName = "example.db";
  static final int version =1;
  static final String tableName = "MYINFO";
  static final  columnId='id';
  static final  columnName='name';
  DatabaseHelper._();
  static final DatabaseHelper instance =DatabaseHelper._();

  static Database _database;
  Future<Database> get database async{
    if(_database!=null) return _database;

    _database = await init();
    return _database;
  }

  init() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,dbName);
    return await openDatabase(path,version: version,onCreate: (Database db,int version){
      db.execute(
        '''
        CREATE TABLE $tableName (
          $columnId INTEGER PRIMARY KEY,
          $columnName TEXT NOT NULL
         )
        '''
      );
    });

  }

  Future<int> insert(Map<String,dynamic> row)
  async{
      Database db =await instance.database;
      return await db.insert(tableName,row);

  }
  Future<List<Map<String,dynamic>>> fetch()
  async{
    Database db =await instance.database;
    return await db.query(tableName);

  }
  Future<int> update(Map<String,dynamic> row)
  async{
    Database db =await instance.database;
    int id = row[columnId];
    return await db.update(tableName,row,where: '$columnId = ?',whereArgs: [id]);

  }
  Future<int> delete(int id)
  async{
    Database db =await instance.database;
    return await db.delete(tableName,where: '$columnId = ?',whereArgs: [id]);

  }


}