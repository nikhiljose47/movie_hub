import 'package:drift/drift.dart';

class BookmarksTable extends Table {
  TextColumn get id => text()(); // UUID

  TextColumn get userLocalId => text()(); // FK (user)

  IntColumn get movieId => integer()();

  TextColumn get title => text()();

  TextColumn get posterPath => text().nullable()();

  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}