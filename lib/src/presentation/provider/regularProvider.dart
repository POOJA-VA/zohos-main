import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zohomain/src/data/datasource/local/sqflite.dart';
import 'package:zohomain/src/data/repository/login.dart';
import 'package:zohomain/src/domain/Modal/regularization.dart';

final pendingRegularizationProvider = FutureProvider<List<RegularizationData>>(
  (ref) async {
    final data = await RegularizationProvider().fetchPendingRegularization();
    return data;
  },
);

final approvedRegularizationProvider = FutureProvider<List<RegularizationData>>(
  (ref) async {
    final data = await RegularizationProvider().fetchApprovedRegularization();
    return data;
  },
);

final rejectedRegularizationProvider = FutureProvider<List<RegularizationData>>(
  (ref) async {
    final data = await RegularizationProvider().fetchRejectedRegularization();
    return data;
  },
);

final regularizationProvider =
    StateNotifierProvider<RegularizationProvider,List<RegularizationData>>(
        (ref) => RegularizationProvider());

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> showNotification(String title, String desc) async {
  // Define notification details
   AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your_channel_id',
    title,
    channelDescription: desc,
    importance: Importance.max,
    priority: Priority.high,
    // Configure notification actions
  );
  final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    UniqueKey().hashCode, // Notification ID
    title,
    desc,
    platformChannelSpecifics,
    payload: 'status',
  );
}

class RegularizationProvider extends StateNotifier<List<RegularizationData>> {
  RegularizationProvider() : super([]);

  Future<List<RegularizationData>> fetchPendingRegularization() async {
    final dataSource = ProjectDataSource();
    final List<RegularizationData> regularizationPendingDataList =
        await dataSource.getPendingRegularization();
    state = regularizationPendingDataList;
    return regularizationPendingDataList;
  }

  Future<List<RegularizationData>> fetchApprovedRegularization() async {
    final dataSource = ProjectDataSource();
    final List<RegularizationData> regularizationApprovedDataList =
        await dataSource.getApprovedRegularization();
    state = regularizationApprovedDataList;
    return regularizationApprovedDataList;
  }

  Future<List<RegularizationData>> fetchRejectedRegularization() async {
    final dataSource = ProjectDataSource();
    final List<RegularizationData> regularizationRejectedDataList =
        await dataSource.getRejectedRegularization();
    state = regularizationRejectedDataList;
    return regularizationRejectedDataList;
  }

  void insertRegularization(RegularizationData data) async {
    final dataSource = ProjectDataSource();
    await dataSource.insertRegularization(data);
    fetchPendingRegularization();
  }

  void updateRegularization (int? id, String status) async{
    final dataSource = ProjectDataSource();
    await dataSource.updateRegularization(id!, status);
    fetchPendingRegularization();
  }
}


final statusProvider = ChangeNotifierProvider<StatusListController>((ref) => StatusListController());
class StatusListController extends ChangeNotifier {
  List<RegularizationData> pendingList = [];
  List<RegularizationData> approvedList = [];
  List<RegularizationData> rejectedList = [];

  DatabaseProjectRepository dbRepo = DatabaseProjectRepository(ProjectDataSource());
  void setPendingList() async{
    pendingList = await dbRepo.getPendingRegularization();
    notifyListeners();
  }

    void setApprovedList() async{
    approvedList = await dbRepo.getApprovedRegularization();
    notifyListeners();
  }

    void setRejectedList() async{
    rejectedList = await dbRepo.getRejectedRegularization();
    notifyListeners();
  }
}