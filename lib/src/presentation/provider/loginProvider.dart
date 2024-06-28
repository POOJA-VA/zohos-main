import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zohomain/src/data/datasource/local/sqflite.dart';
import 'package:zohomain/src/data/repository/login.dart';
import 'package:zohomain/src/domain/repository/login.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref.read(projectRepositoryProvider));
});

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return DatabaseProjectRepository(ref.read(databaseHelperProvider));
});

final databaseHelperProvider = Provider<ProjectDataSource>((ref) {
  return ProjectDataSource();
});

class AuthNotifier extends StateNotifier<bool> {
  final ProjectRepository _repository;
  AuthNotifier(this._repository) : super(false);

  Future<bool> login(String userName, String userPassword) async {
    final result = await _repository.login(userName, userPassword);
    state = result;
    return result;
  }

  Future<void> signup(String userName, String userPassword) async {
    await _repository.signup(userName, userPassword);
    state = true;
  }
}