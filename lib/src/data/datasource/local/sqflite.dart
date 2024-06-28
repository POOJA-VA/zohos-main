import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zohomain/src/domain/Modal/regularization.dart';
import 'package:zohomain/src/domain/repository/login.dart';

class ProjectDataSource implements ProjectRepository {
  final String databaseName = "zohos.db";

  final String users =
      "CREATE TABLE users (userId INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT UNIQUE, userPassword TEXT)";

  final String regularization =
      "CREATE TABLE regularization (id INTEGER PRIMARY KEY AUTOINCREMENT, employeeName TEXT, date TEXT, checkInTime TEXT, checkOutTime TEXT, hours INTEGER, dropdownValue TEXT, status TEXT)";

  final String checkInOutTable =
      "CREATE TABLE checkinout (id INTEGER PRIMARY KEY, title TEXT, checkin TEXT, checkout TEXT, hours TEXT)";

  final String checkInTimeTable =
      "CREATE TABLE checkintime (id INTEGER PRIMARY KEY, hours INTEGER, minutes INTEGER, seconds INTEGER)";

  Future<Database> initDB() async {
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, databaseName);
    // await deleteDatabase(path);
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(users);
      await db.execute(regularization);
      await db.execute(checkInOutTable);
      await db.execute(checkInTimeTable);
    });
  }

  @override
  Future<int?> getUserId(String email) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['userId'],
      where: 'userName = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result.first['userId'] as int?;
    } else {
      return null;
    }
  }

  @override
  Future<bool> login(String userName, String userPassword) async {
    final Database db = await initDB();

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'userName = ? AND userPassword = ?',
      whereArgs: [userName, userPassword],
    );
    return result.isNotEmpty;
  }

  @override
  Future<void> signup(String userName, String userPassword) async {
    final Database db = await initDB();

    try {
      await db.insert(
        'users',
        {'userName': userName, 'userPassword': userPassword},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
    } finally {
      await db.close();
    }
  }

  @override
  Future<List<RegularizationData>> getPendingRegularization() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> result = await db
        .query('regularization', where: "status=?", whereArgs: ["Pending"]);
    // await db.close();
    return result.map((map) => RegularizationData.fromMap(map)).toList();
  }

  @override
  Future<List<RegularizationData>> getApprovedRegularization() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> result = await db
        .query('regularization', where: "status=?", whereArgs: ["Approved"]);
    // await db.close();
    return result.map((map) => RegularizationData.fromMap(map)).toList();
  }

  @override
  Future<List<RegularizationData>> getRejectedRegularization() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> result = await db
        .query('regularization', where: "status=?", whereArgs: ["Rejected"]);
    // await db.close();
    return result.map((map) => RegularizationData.fromMap(map)).toList();
  }

  @override
  Future<void> insertRegularization(RegularizationData data) async {
    final Database db = await initDB();
    await db.insert(
      'regularization',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // await db.close();
  }

  Future<void> updateRegularization(int id, String status) async {
    final Database db = await initDB();
    await db.update(
      'regularization',
      {"status": status},
      where: "id = ?",
      whereArgs: [id],
    );
    // await db.close();
  }

  Future<void> insertReport(Map<String, dynamic> data) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, dd MMMM').format(now);
    final Database db = await initDB();
    List<Map<String, dynamic>> title = await db
        .rawQuery("SELECT title FROM checkinout WHERE title='$formattedDate'");
    if (title.length == 0) {
      await db.insert(
        'checkinout',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      List<Map<String, dynamic>> hrs = await db.rawQuery(
          "SELECT hours FROM checkinout WHERE title='$formattedDate'");
      double final_hrs =
          double.parse(hrs.first.values.elementAt(0).replaceAll(":", "."));
      double current_hrs = double.parse(data['hours'].replaceAll(":", "."));
      String total_hrs =
          (final_hrs + current_hrs).toString().replaceAll(".", ":");
      await db.rawUpdate(
          "UPDATE checkinout SET hours = ?,checkout = ? WHERE title = '$formattedDate'",
          [total_hrs, data['checkout']]);
    }
  }

  Future<List<Map<String, dynamic>>> getReports() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> result = await db.query('checkinout');
    // print('$result');
    return result;
  }

  Future<List<double>> getHours(DateTime startDate, int weeks) async {
    final Database db = await initDB();
    List<DateTime> lastWeekList = getDateList(startDate, weeks);
    List<double> hours = [00.00, 00.00, 00.00, 00.00, 00.00, 00.00, 00.00];
    DateFormat dateFormat = DateFormat('EEEE, dd MMMM');
    for (DateTime date in lastWeekList) {
      List<Map<String, dynamic>> hour = await db.rawQuery(
          "SELECT title, hours FROM checkinout WHERE title='${dateFormat.format(date)}'");
      // print('$date');
      if (hour.isNotEmpty && hour.length > 0) {
        if (hour.first['title'].split(",")[0] == 'Monday') {
          hours[0] = double.parse(hour.first['hours'].replaceAll(":", "."));
        } else if (hour.first['title'].split(",")[0] == 'Tuesday') {
          hours[1] = double.parse(hour.first['hours'].replaceAll(":", "."));
        } else if (hour.first['title'].split(",")[0] == 'Wednesday') {
          hours[2] = double.parse(hour.first['hours'].replaceAll(":", "."));
        } else if (hour.first['title'].split(",")[0] == 'Thursday') {
          hours[3] = double.parse(hour.first['hours'].replaceAll(":", "."));
        } else if (hour.first['title'].split(",")[0] == 'Friday') {
          hours[4] = double.parse(hour.first['hours'].replaceAll(":", "."));
        } else if (hour.first['title'].split(",")[0] == 'Saturday') {
          hours[5] = double.parse(hour.first['hours'].replaceAll(":", "."));
        } else if (hour.first['title'].split(",")[0] == 'Sunday') {
          hours[6] = double.parse(hour.first['hours'].replaceAll(":", "."));
        }
      }
    }
    // print('$hours');
    return hours;
  }

  List<DateTime> getDateList(DateTime startDate, int weeks) {
    List<DateTime> weekDates = [];
    // print('Start date: $startDate');
    for (int j = 0; j < weeks; j++) {
      DateTime sunday =
          startDate.subtract(Duration(days: startDate.weekday - 1 + j * 7));
      weekDates.add(sunday);
      for (int i = 1; i < 7; i++) {
        DateTime nextDay = sunday.add(Duration(days: i));
        weekDates.add(nextDay);
      }
    }
    // print('$weekDates');
    return weekDates;
  }
}