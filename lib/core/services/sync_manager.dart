import 'package:movie_hub/services/users/user_repository.dart';

class SyncManager {
  final UserRepository repo;

  bool _isSyncing = false;

  SyncManager(this.repo);

  Future<void> syncIfNeeded() async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      await repo.syncUsers();
    } finally {
      _isSyncing = false;
    }
  }
}