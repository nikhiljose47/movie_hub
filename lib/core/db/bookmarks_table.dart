import 'package:drift/drift.dart';

class BookmarksTable extends Table {
  TextColumn get id => text()(); 

  TextColumn get userLocalId => text()();

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