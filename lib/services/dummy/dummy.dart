import 'package:movie_hub/models/user.dart';

class DummyApi {
  static Future<List<User>> fetchUsers(int page) async {
    await Future.delayed(const Duration(seconds: 1));

    if (page > 5) return []; // simulate end

    return List.generate(20, (index) {
      final id = (page - 1) * 10 + index;
      return User(
        id: id,
        firstName: 'User$id',
        lastName: 'Test$id',
        avatar: 'https://i.pravatar.cc/150?img=${id % 70}',
      );
    });
  }
}