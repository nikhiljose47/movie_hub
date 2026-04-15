import 'package:workmanager/workmanager.dart';
import '../di/service_locator.dart';
import 'sync_manager.dart';

const String syncTask = "syncTask";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // IMPORTANT: re-init dependencies
    await setupLocator();

    final syncManager = sl<SyncManager>();

    if (task == syncTask) {
      print('🔄 WorkManager Sync Running...');
      await syncManager.syncIfNeeded();
    }

    return Future.value(true);
  });
}