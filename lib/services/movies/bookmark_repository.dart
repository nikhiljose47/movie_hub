import 'package:movie_hub/core/db/app_database.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

class BookmarkRepository {
  final AppDatabase db;
  final _uuid = const Uuid();

  BookmarkRepository(this.db);

  Future<void> toggleBookmark({
    required String userId,
    required int movieId,
    required String title,
    String? poster,
  }) async {
    final existing =
        await (db.select(db.bookmarksTable)..where(
              (b) => b.userLocalId.equals(userId) & b.movieId.equals(movieId),
            ))
            .getSingleOrNull();

    if (existing != null) {
      await (db.delete(
        db.bookmarksTable,
      )..where((b) => b.id.equals(existing.id))).go();
    } else {
      await db
          .into(db.bookmarksTable)
          .insert(
            BookmarksTableCompanion.insert(
              id: _uuid.v4(),
              userLocalId: userId,
              movieId: movieId,
              title: title,
              posterPath: Value(poster),
            ),
          );
    }
  }

  Future<List<BookmarksTableData>> getBookmarks(String userId) {
    return (db.select(
      db.bookmarksTable,
    )..where((b) => b.userLocalId.equals(userId))).get();
  }

  Stream<List<BookmarksTableData>> watchBookmarks(String userId) {
    return (db.select(
      db.bookmarksTable,
    )..where((b) => b.userLocalId.equals(userId))).watch();
  }

  Future<bool> isBookmarked(String userId, int movieId) async {
    final res =
        await (db.select(db.bookmarksTable)..where(
              (b) => b.userLocalId.equals(userId) & b.movieId.equals(movieId),
            ))
            .getSingleOrNull();

    return res != null;
  }
}
