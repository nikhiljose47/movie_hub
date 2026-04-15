import 'package:drift/drift.dart';

class UsersTable extends Table {
  TextColumn get localId => text()();

  TextColumn get name => text()();
  TextColumn get job => text()();

  TextColumn get serverId => text().nullable()();

  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {localId};
}