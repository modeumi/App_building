import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tamer/database/SQLite_dataset.dart';
import 'package:tamer/model/user_information.dart';

class SaveData{
  Database? database;
  User_Data? user_data;

  Future<Database> _initeDB() async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, 'tamer.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE tamer(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        level INTEGER DEFAULT '1',
        inventory_name TEXT DEFAULT 'slime,nomal',
        inventory_amount TEXT DEFAULT '10,2',
        souls_name TEXT DEFAULT 'slime',
        souls_level TEXT DEFAULT '1',
        map_name TEXT DEFAULT '',
        map_clear TEXT DEFAULT '',
        pick_count INTEGER DEFAULT '0',
        exp INTEGER DEFAULT '0',
        save_time TEXT DEFAULT CURRENT_TIMESTAMP)
        ''');
      },
    );
  }

  Future<void> save_data(user_information user) async{
    String inven_name = user.user_inventory.keys.toList().join(',');
    String inven_amount = user.user_inventory.values.toList().join(',');
    String map_name = user.user_clear.keys.toList().join(',');
    String map_clear = user.user_clear.values.toList().join(',');
    String souls_name = user.user_souls.keys.toList().join(',');
    String souls_level = user.user_souls.values.toList().join(',');
    user_data= User_Data(
      id: user.user_id,
        name: user.user_name,
        level : user.user_level,
      inventory_name: inven_name,
      inventory_amount: inven_amount,
      souls_name: souls_name,
      souls_level: souls_level,
      map_name: map_name,
      map_clear: map_clear,
      pick_count: user.user_pick_count,
      exp: user.user_exp,
      save_time: DateTime.now().toString()
    );
    final db = await _initeDB();
    await db.update('tamer', user_data!.toMap(),
        where: 'id = ?', whereArgs: [user_data!.id]);
  }
}