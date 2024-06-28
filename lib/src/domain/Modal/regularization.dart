import 'package:flutter/material.dart';

class RegularizationData {
  final int? id;
  final String employeeName;
  final String date;
  final TimeOfDay checkInTime;
  final TimeOfDay checkOutTime;
  final int hours;
  final String dropdownValue;
  final String status;

  RegularizationData({
    this.id,
    required this.employeeName,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.hours,
    required this.dropdownValue,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeName': employeeName,
      'date': date.toString(),
      'checkInTime': '${checkInTime.hour}:${checkInTime.minute}',
      'checkOutTime': '${checkOutTime.hour}:${checkOutTime.minute}',
      'hours': hours,
      'dropdownValue': dropdownValue,
      'status': status,
    };
  }

  factory RegularizationData.fromMap(Map<String, dynamic> map) {
    late TimeOfDay checkInTime;
    late TimeOfDay checkOutTime;
    try {
       checkInTime = TimeOfDay(
        hour: int.parse(map['checkInTime'].split(':')[0]),
        minute: int.parse(map['checkInTime'].split(':')[1]),
      );
    } catch (e) {
      print("Error parsing check-in time: $e");
    }

    try {
      checkOutTime = TimeOfDay(
        hour: int.parse(map['checkOutTime'].split(':')[0]),
        minute: int.parse(map['checkOutTime'].split(':')[1]),
      );
    } catch (e) {
      print("Error parsing check-out time: $e");
    }

    return RegularizationData(
      id: map['id'],
      employeeName: map['employeeName'],
      date: map['date'].toString(),
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      hours: map['hours'],
      dropdownValue: map['dropdownValue'],
      status: map['status'],
    );
  }
}