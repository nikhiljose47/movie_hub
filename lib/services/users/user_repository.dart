import 'package:movie_hub/core/db/app_database.dart';
import 'package:movie_hub/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../../services/users/user_api_service.dart';

class UserRepository {
  final AppDatabase db;
  final UserApiService api;
  final _uuid = const Uuid();

  bool isSyncing = false;

  UserRepository({required this.db, required this.api});

  Future<List<User>> getUsers(int page) async {
    final remote = await api.fetchUsers(page);
    final local = await db.getAllUsers();

    return [
      ...local.map((e) => User(
            id: e.id,
            firstName: e.name,
            lastName: '',
            avatar: '',
          )),
      ...remote,
    ];
  }

  Future<void> addUser({
    required String name,
    required String job,
  }) async {
    final id = _uuid.v4();

    await db.into(db.usersTable).insert(
          UsersTableCompanion.insert(
            id: id,
            name: name,
            job: job,
          ),
        );

    syncUsers();
  }

  Future<void> syncUsers() async {
    if (isSyncing) return;
    isSyncing = true;

    final users = await (db.select(db.usersTable)
          ..where((u) => u.isSynced.equals(false)))
        .get();

    for (final u in users) {
      final res = await api.createUser(
        //id: u.id,
        name: u.name,
        job: u.job,
      );

      if (res != null) {
        await (db.update(db.usersTable)
              ..where((x) => x.id.equals(u.id)))
            .write(const UsersTableCompanion(
              isSynced: Value(true),
            ));
      } else {
        break;
      }
    }

    isSyncing = false;
  }
}