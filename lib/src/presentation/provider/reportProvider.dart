import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zohomain/src/data/datasource/local/sqflite.dart';

final checkInOutProvider =
    StateNotifierProvider<CheckInOutProvider, List<Map<String, dynamic>>>(
        (ref) {
  return CheckInOutProvider();
});

class CheckInOutProvider extends StateNotifier<List<Map<String, dynamic>>> {
  CheckInOutProvider() : super([]);

  void fetchCheckInOutList(DateTime startOfWeek, DateTime endOfWeek) async {
    final dataSource = ProjectDataSource();
    final List<Map<String, dynamic>> checkInOutList =
        await dataSource.getReports();

    List<Map<String, dynamic>> completeList = [];
    for (int i = 0; i < 7; i++) {
      DateTime currentDay = startOfWeek.add(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDay);

      bool isPresent = false;
      for (var entry in checkInOutList) {
        if (entry['title'] == DateFormat('EEEE, dd MMMM').format(currentDay)) {
          completeList.add({
            'date': formattedDate,
            'checkin': entry['checkin'] ?? '--:--:--',
            'checkout': entry['checkout'] ?? '--:--:--',
            'hours': entry['hours'] ??
                (currentDay.weekday == DateTime.saturday ||
                        currentDay.weekday == DateTime.sunday
                    ? 'Weekend'
                    : 'Absent')
          });
          isPresent = true;
          break;
        }
      }

      if (!isPresent) {
        completeList.add({
          'date': formattedDate,
          'checkin': '--:--:--',
          'checkout': '--:--:--',
          'hours': (currentDay.weekday == DateTime.saturday ||
                  currentDay.weekday == DateTime.sunday)
              ? 'Weekend'
              : 'Absent'
        });
      }
    }

    completeList.forEach((entry) {
      if (entry['checkin'] != '00:00:00' &&
          entry['checkout'] != '00:00:00' &&
          entry['hours'] != 'Weekend' &&
          entry['hours'] != 'Absent') {
        DateTime checkIn = DateFormat('yyyy-MM-dd HH:mm:ss')
            .parse(entry['date'] + ' ' + entry['checkin']);
        DateTime checkOut = DateFormat('yyyy-MM-dd HH:mm:ss')
            .parse(entry['date'] + ' ' + entry['checkout']);
        
        Duration difference = checkOut.difference(checkIn);
        int hours = difference.inHours;
        int minutes = difference.inMinutes.remainder(60);
        
        entry['hours'] = '$hours:${minutes}';
      }
    });

    state = completeList;
  }

  void insertCheckInOut(Map<String, dynamic> data, DateTime startOfWeek,
      DateTime endOfWeek) async {
    final dataSource = ProjectDataSource();
    await dataSource.insertReport(data);
    fetchCheckInOutList(startOfWeek, endOfWeek);
  }
}