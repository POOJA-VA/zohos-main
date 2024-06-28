import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userListProvider = StateNotifierProvider<UserListNotifier, AsyncValue<List<dynamic>>>(
  (ref) => UserListNotifier(),
);

class UserListNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  UserListNotifier() : super(const AsyncValue.loading()) {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      const url = 'https://randomuser.me/api/?results=20';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final body = response.body;
        final json = jsonDecode(body);
        state = AsyncValue.data(json['results']);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error) {
      state = AsyncValue.error(error);
    }
  }
}