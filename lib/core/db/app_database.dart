import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'users_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [UsersTable],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<UsersTableData>> getAllUsers() {
    return select(usersTable).get();
  }

  Future<List<UsersTableData>> getUnsyncedUsers() {
    return (select(usersTable)
          ..where((u) => u.isSynced.equals(false)))
        .get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.db'));

    return NativeDatabase(file);
  });
}