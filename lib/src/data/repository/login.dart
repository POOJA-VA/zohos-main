import 'package:zohomain/src/data/datasource/local/sqflite.dart';
import 'package:zohomain/src/domain/Modal/regularization.dart';
import 'package:zohomain/src/domain/repository/login.dart';

class DatabaseProjectRepository implements ProjectRepository {
  final ProjectDataSource _dataSource;

  DatabaseProjectRepository(this._dataSource);

  @override
  Future<bool> login(String userName, String userPassword) async {
    return await _dataSource.login(userName, userPassword);
  }

  @override
  Future<void> signup(String userName, String userPassword) async {
    return await _dataSource.signup(userName, userPassword);
  }

  @override
  Future<int?> getUserId(String email) async {
    return await _dataSource.getUserId(email);
  }

  @override
  Future<void> insertRegularization(RegularizationData data) async {
    return await _dataSource.insertRegularization(data);
  }

  @override
  Future<List<RegularizationData>> getPendingRegularization() async {
    return await _dataSource.getPendingRegularization();
  }

  @override
  Future<List<RegularizationData>> getApprovedRegularization() async {
    return await _dataSource.getApprovedRegularization();
  }

  @override
  Future<List<RegularizationData>> getRejectedRegularization() async {
    return await _dataSource.getRejectedRegularization();
  }

  @override
  Future<List<Map<String, dynamic>>> getReports() async {
    return await _dataSource.getReports();
  }

  @override
  Future<void> insertReport(Map<String, dynamic> data) async {
    return await _dataSource.insertReport(data);
  }
}