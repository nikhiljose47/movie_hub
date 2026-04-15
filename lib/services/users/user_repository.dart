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

    final localUsers = local
        .map((e) => User(id: 0, firstName: e.name, lastName: '', avatar: ''))
        .toList();

    return [...localUsers, ...remote];
  }

  Future<void> addUser({required String name, required String job}) async {
    final localId = _uuid.v4();
    await db
        .into(db.usersTable)
        .insert(
          UsersTableCompanion.insert(localId: localId, name: name, job: job),
        );

        
    await syncUsers();
  }

  Future<void> syncUsers() async {
    if (!isSyncing) {
      isSyncing = true;
      final unsyncedUsers = await (db.select(
        db.usersTable,
      )..where((u) => u.isSynced.equals(false))).get();

      for (final user in unsyncedUsers) {
        try {
          final res = await api.createUser(name: user.name, job: user.job);

          if (res != null) {
            await (db.update(
              db.usersTable,
            )..where((u) => u.localId.equals(user.localId))).write(
              UsersTableCompanion(
                serverId: Value(res.createdId),
                isSynced: const Value(true),
              ),
            );
          }
        } catch (e) {
          break; // stop → retry later
        }
      }
      isSyncing = false;
    }
  }
}
