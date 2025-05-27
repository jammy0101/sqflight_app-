import 'package:sqflight_app/notes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DBHandler {

  static Database? _database;


  Future<Database?> get db async{

    if(_database != null){
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase()async{
    io.Directory documentDirectory =  await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes_db');
    var db = await openDatabase(path,version: 1,onCreate: _onCreate);
    return db;
  }

  _onCreate (Database db , int version)async{
    await db.execute(
      "CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL,age INTEGER NOT NULL,description TEXT NOT NULL ,email TEXT )"
    );
  }

  Future<NotesModel>  insert(NotesModel notesModel)async{
    var dbClient = await db;
    await dbClient!.insert('notes', notesModel.toMap());
    return notesModel;
  }

  Future<List<NotesModel>>  getNotesList()async{
    var dbClient = await db;
    final List<Map<String,Object?>>  queryResult = await dbClient!.query('notes');
    return queryResult.map((e) => NotesModel.fromJson(e)).toList();
  }

  Future<int> delete(int id)async{
    var dbClient = await db;
    return await dbClient!.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

}

