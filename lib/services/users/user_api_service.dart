import 'package:movie_hub/core/network/dio_client.dart';
import 'package:movie_hub/models/user.dart';

class UserApiService {
  final DioClient _client;

  UserApiService(this._client);

  Future<List<User>> fetchUsers(int page) async {
    try {
      final response = await _client.get('/users', query: {'page': page});
      final List data = response.data['data'] ?? [];
      return data.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<User?> createUser({required String name, required String job}) async {
    try {
      final response = await _client.post(
        '/users',
        data: {"name": name, "job": job},
      );

      return User.fromCreateResponse(response.data);
    } catch (e) {
      return null;
    }
  }
}
