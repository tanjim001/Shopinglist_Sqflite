import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlcrud/constant.dart';
import 'package:sqlcrud/model.dart';
import 'package:sqlcrud/readalldata.dart';

class DataClass {
  Database? _db;

  Future<Database> initdb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "cruddb.db");
    var db = await openDatabase(path, version: 1, onCreate: oncreate);
    return db;
  }

  void oncreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE crudmodels(${Constant.name} TEXT, ${Constant.description} TEXT, ${Constant.price} DOUBLE)");
  }

  Future<Database> get db async {
    if (_db == null) {
      _db = await initdb();
      return _db!;
    } else {
      return _db!;
    }
  }

  Future<int> create(Crudmodel crud) async {

    await initdb();
    var dbready = await db;
    return await dbready.rawInsert(
        "INSERT INTO crudmodels(${Constant.name},${Constant.description},${Constant.price}) VALUES ('${crud.name}','${crud.description}','${crud.price}')");
  }

  Future<int> update(Crudmodel crud) async {
    var dbready = await db;
    return await dbready.rawUpdate(
        "UPDATE crudmodels SET ${Constant.description}='${crud.description}',${Constant.price}='${crud.price}' WHERE ${Constant.name}='${crud.name}'");
  }

  Future<int> delete(String name) async {
    var dbready = await db;
    return await dbready.rawDelete("DELETE FROM crudmodels WHERE ${Constant.name}='$name'");
  }

  Future<Crudmodel?> read(String name) async {
    var dbready = await db;
    var read =
        await dbready.rawQuery("SELECT * FROM crudmodels WHERE ${Constant.name}='$name'");
    if (read.isNotEmpty) {
      return Crudmodel.fromMap(read[0]);
    } else {
      return null; // Handle case when no data is found
    }
  }
  Future<ReadAllResult>readAll()async{
    var dbready=await db;
    double total=0;
    List<Map>list=await dbready.rawQuery("SELECT * FROM crudmodels");
    List<Crudmodel>data=[];
    for(int i=0;i<list.length;i++){
      data.add(Crudmodel(name: list[i]["name"], price:list[i]["price"], description: list[i]["description"]));
      if(list[i]["price"]!=null){
        total += list[i]["price"];
      }
    }
   return ReadAllResult(data, total);
  }
}
