import 'package:drift/drift.dart';

class SyncQueueTable extends Table {
  TextColumn get id => text()(); // UUID

  TextColumn get type => text()(); // CREATE_USER

  TextColumn get payload => text()(); // JSON string

  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}