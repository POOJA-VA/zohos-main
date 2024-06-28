import 'package:zohomain/src/domain/Modal/regularization.dart';

abstract class ProjectRepository {
  Future<int?> getUserId(String email);
  Future<bool> login(String userName, String userPassword);
  Future<void> signup(String userName, String userPassword);
  Future<void> insertRegularization(RegularizationData data);
  Future<List<RegularizationData>> getPendingRegularization();
  Future<List<RegularizationData>> getApprovedRegularization();
  Future<List<RegularizationData>> getRejectedRegularization();
  Future<void> insertReport(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getReports();
}