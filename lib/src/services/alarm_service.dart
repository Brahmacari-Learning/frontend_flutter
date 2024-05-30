import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vedanta_frontend/main.dart';
import 'package:vedanta_frontend/src/data/models/alarm_info.dart';

void scheduleAlarm() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'alarm',
    'Alarm',
    channelDescription: 'Pengingat Doa',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  flutterLocalNotificationsPlugin.show(
    0,
    'plain title',
    'hello world',
    notificationDetails,
    payload: 'item x',
  );
}

const String tableAlarm = 'alarm';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDateTime = 'alarmDateTime';
const String columnPending = 'isPending';
const String columnColorIndex = 'gradientColorIndex';

class AlarmHelper {
  static Database? _database;
  static AlarmHelper? _alarmHelper;

  AlarmHelper._createInstance();
  factory AlarmHelper() {
    _alarmHelper ??= AlarmHelper._createInstance();
    return _alarmHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = "${dir}alarm.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $tableAlarm ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null,
          $columnDateTime text not null,
          $columnPending integer,
          $columnColorIndex integer)
        ''');
      },
    );
    return database;
  }

  void insertAlarm(AlarmInfo alarmInfo) async {
    var db = await database;
    await db.insert(tableAlarm, alarmInfo.toMap());
  }

  Future<List<AlarmInfo>> getAlarms() async {
    List<AlarmInfo> alarms = [];

    var db = await database;
    var result = await db.query(tableAlarm);
    for (var element in result) {
      var alarmInfo = AlarmInfo.fromMap(element);
      alarms.add(alarmInfo);
    }

    return alarms;
  }

  Future<int> delete(int? id) async {
    var db = await database;
    return await db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }
}
