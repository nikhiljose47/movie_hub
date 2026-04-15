import 'package:flutter/material.dart';
import 'package:movie_hub/core/di/service_locator.dart';
import 'package:movie_hub/core/services/connectivity_service.dart';
import 'package:movie_hub/core/services/sync_manager.dart';
import 'package:movie_hub/core/services/workmanager_service.dart';
import 'package:movie_hub/screens/user_list_screen.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  Workmanager().initialize(callbackDispatcher);

  Workmanager().registerPeriodicTask(
    "sync-task-id",
    syncTask,
    frequency: const Duration(minutes: 15),
  );

  final connectivity = sl<ConnectivityService>();
  final syncManager = sl<SyncManager>();
  connectivity.onStatusChange.listen((isOnline) async {
    if (isOnline) {
      print('Internet back...');
      await syncManager.syncIfNeeded();
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Movie Hub",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.amber[200],
        ),
        body: const UserListScreen(),
      ),
    );
  }
}
