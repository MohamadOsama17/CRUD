import 'dart:async';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import './employee.dart';


class DBHelper{
  static Database _db;
  //Column Name
  static const String ID='id';
  static const String NAME='name';
  //Table Name
  static const String TABLE='Employee';
  static const String DB_NAME='employee.db';

//this for check if there a database or not
//if there a database then get it
//if no database then create one 
  Future<Database> get db async{
    if(_db != null){
    return _db;}
    _db = await initDb();
    return _db;
  }

//create and open database
  initDb()async{
    io.Directory dataDirectory = await getApplicationDocumentsDirectory();
    String path= join(dataDirectory.path, DB_NAME);
    var db = openDatabase(path, version: 1,
      //create database
     onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db , int version)async{
    await db.execute('CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY , $NAME TEXT )');
  }

//this is to save(insert) data to database
  Future<Employee> save(Employee employee) async{
    var dbClient = await db;
    employee.id=await dbClient.insert(TABLE, employee.toMap());
    return employee;
  }


//this is to get all data from database as List
  Future<List<Employee>> getEmployees()async{
    var dbClient = await db;
    List<Map> maps =await dbClient.query(TABLE,columns: [ID,NAME]);
    List<Employee> employees =[];
    if(maps.length>0){
      for(int i =0 ; i<maps.length;i++){
        employees.add(Employee.fromMap(maps[i]));
      }
    }
    return employees;
  }

//this for delete from TABLE by id
  Future<int> delete(int id) async{
    var dbClient =await db;
    return await dbClient.delete(TABLE,where: '$ID=?' ,whereArgs: [id]);
  }

//this for update value using id
  Future <int> update(Employee employee) async{
    var dbClient = await db;
    return await dbClient.update(TABLE, employee.toMap(),
      where: '$ID=?',whereArgs: [employee.id]);
  }

  Future close() async{
    var dbClient =await db;
    dbClient.close();
  }
}
