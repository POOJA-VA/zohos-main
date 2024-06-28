import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zohomain/src/data/datasource/local/sqflite.dart';

class CheckInProvider extends ChangeNotifier {
  late Timer _timer;
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  bool _isCheckedIn = false;
  DateTime? _checkInTime;
  DateTime? _checkOutTime;
  List<Map<String, dynamic>> _checkInOutList = [];
  late ProjectDataSource _databaseHelper;

  CheckInProvider() {
    _databaseHelper = ProjectDataSource();
  }

  int get hours => _hours;
  int get minutes => _minutes;
  int get seconds => _seconds;
  bool get isCheckedIn => _isCheckedIn;
  DateTime? get checkInTime => _checkInTime;
  DateTime? get checkOutTime => _checkOutTime;
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds++;
      if (_seconds == 60) {
        _seconds = 0;
        _minutes++;
        if (_minutes == 60) {
          _minutes = 0;
          _hours++;
        }
      }
      notifyListeners();
    });
  }

    void resetTime() {
    _hours = 0;
    _minutes = 0;
    _seconds = 0;
    notifyListeners();
  }

  void stopTimer() {
    _timer.cancel();
  }

  Future<void> toggleCheckIn() async {
    _isCheckedIn = !_isCheckedIn;
    if (_isCheckedIn) {
      _checkInTime = DateTime.now();
      startTimer();
    } else {
      _checkOutTime = DateTime.now();
      stopTimer();
      await _saveCheckInOut();
    }
    notifyListeners();
  }

  Future<void> _saveCheckInOut() async {
    final DateFormat formatter = DateFormat('HH:mm:ss');
    final String formattedCheckInTime = formatter.format(_checkInTime!);
    final String formattedCheckOutTime = formatter.format(_checkOutTime!);
    final String formattedDate =
        DateFormat('EEEE, dd MMMM').format(_checkInTime!);

    final Map<String, dynamic> data = {
      'title': formattedDate,
      'checkin': formattedCheckInTime,
      'checkout': formattedCheckOutTime,
      'hours': _calculateHours(_checkInTime!, _checkOutTime!),
    };

    await _databaseHelper.insertReport(data);
    _checkInOutList = await _databaseHelper.getReports();
    notifyListeners();
  }

  String _calculateHours(DateTime checkInTime, DateTime checkOutTime) {
    final Duration difference = checkOutTime.difference(checkInTime);
    final int hours = difference.inHours;
    final int minutes = difference.inMinutes.remainder(60);
    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }

  List<Map<String, dynamic>> get checkInOutList => _checkInOutList;
}