import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Alarm.dart';
import 'Timer.dart';

final _databaseName = 'alarm_app.db';

// Open the database and store the reference.
final Future<Database> database = getDatabasesPath().then((String path) {
  return openDatabase(
    join(path, _databaseName),
    onCreate: (db, version) {
      return db.execute(
        "create table alarms("
        "id integer primary key autoincrement,"
        "hour integer not null,"
        "minute integer not null,"
        "isActive integer not null)" // 0 or 1
        "create table timers("
        "id integer primary key autoincrement,"
        "duration integer not null)",
      );
    },
    version: 1,
  );
});

Future<void> insertAlarm(Alarm alarm) async {
  final Database db = await database;

  await db.insert('alarms', alarm.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<void> updateAlarm(Alarm alarm) async {
  final db = await database;

  await db
      .update('alarms', alarm.toMap(), where: "id = ?", whereArgs: [alarm.id]);
}

Future<void> deleteAlarm(Alarm alarm) async {
  final db = await database;

  await db.delete('alarms', where: "id = ?", whereArgs: [alarm.id]);
}

Future<List<Alarm>> getAlarms() async {
  final db = await database;

  final List<Map<String, dynamic>> maps = await db.query('alarms');

  return List.generate(maps.length, (i) {
    return Alarm(
      id: maps[i]['id'],
      hour: maps[i]['hour'],
      minute: maps[i]['minute'],
      isActive: maps[i]['isActive'] == 1,
    );
  });
}

Future<List<Timer>> getTimers() async {
  final db = await database;

  final List<Map<String, dynamic>> maps = await db.query('timers');

  return List.generate(maps.length, (i) {
    return Timer(
      id: maps[i]['id'],
      duration: Duration(seconds: maps[i]['duration']),
    );
  });
}

Future<void> insertTimer(Timer timer) async {
  final Database db = await database;

  await db.insert('timers', timer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<void> deleteTimer(Timer timer) async {
  final db = await database;

  await db.delete('timers', where: "id = ?", whereArgs: [timer.id]);
}
