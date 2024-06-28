import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zohomain/src/data/datasource/local/sqflite.dart';

final hrsProvider =
    ChangeNotifierProvider((ref) => HoursProvider(DateTime.now()));

class HoursProvider extends ChangeNotifier {
  List<double> hrs = [];
  DateTime startDate;
  int weeks = 1; // Adjusted for single week view

  HoursProvider(this.startDate);

  void setHours() async {
    final dataSource = ProjectDataSource();
    hrs = await dataSource.getHours(startDate, weeks);
    notifyListeners();
  }

  // void setPreviousWeek() {
  //   startDate = startDate.subtract(Duration(days: 7));
  //   setHours();
  // }

  void setPreviousWeek() {
    DateTime newStartDate = startDate.subtract(Duration(days: 7));
    if (newStartDate.year == 2024) {
      startDate = newStartDate;
    } else {
      startDate = DateTime(2024, 4);
    }
    setHours();
  }

  void setCurrentWeek() {
    startDate =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    setHours();
  }
}