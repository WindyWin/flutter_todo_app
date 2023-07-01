import 'package:sqflite/sqflite.dart';
import 'package:todo_app/config/database.dart';
import 'package:todo_app/data/models/task.dart';

const String tableTodo = 'todo';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnContent = 'content';
const String columnIsDone = 'isDone';
const String columnCreateAt = 'createAt';

class TaskService {
  static late Database _db;

  static Future open() async {
    var path = await getDatabasesPath() + DATABASE_NAME;
    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableTodo ( 
  $columnId integer primary key autoincrement, 
  
  $columnTitle text not null,
  $columnContent text not null,
  $columnIsDone bool not null,
  $columnCreateAt text not null)
''');
    });
  }

  Future<Task> insert(Task task) async {
    task.id = await _db.insert(tableTodo, task.toMap());
    return task;
  }

  Future<List<Task>> getTasks() async {
    var result = await _db.query(tableTodo,
        columns: [
          columnId,
          columnTitle,
          columnContent,
          columnIsDone,
          columnCreateAt
        ],
        orderBy: '$columnCreateAt DESC');
    List<Task> tasks = [];
    for (var element in result) {
      var task = Task.fromMap(element);
      tasks.add(task);
    }
    return tasks;
  }

  Future<Task?> getTask(int id) async {
    List<Map> maps = await _db.query(tableTodo,
        columns: [
          columnId,
          columnTitle,
          columnContent,
          columnIsDone,
          columnCreateAt
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await _db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Task task) async {
    return await _db.update(tableTodo, task.toMap(),
        where: '$columnId = ?', whereArgs: [task.id]);
  }

  Future close() async => _db.close();
}
