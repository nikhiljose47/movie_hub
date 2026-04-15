import 'package:flutter/material.dart';
import 'package:movie_hub/core/di/service_locator.dart';
import 'package:movie_hub/core/services/connectivity_service.dart';
import 'package:movie_hub/screens/user_list_screen.dart';
import 'package:movie_hub/services/users/user_repository.dart';
import 'package:workmanager/workmanager.dart';

const String syncTask = "syncTask";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(const MyApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await setupLocator();
    final userRepo = sl<UserRepository>();

    if (task == syncTask) {
      await userRepo.syncUsers();
    }
    return Future.value(true);
  });
}

Future<void>   initializeApp() async {
  await setupLocator();

  final userRepo = sl<UserRepository>();
  final connectivity = sl<ConnectivityService>();

  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    "user-sync",
    syncTask,
    frequency: const Duration(minutes: 15),
  );

  connectivity.onStatusChange.listen((isOnline) async {
    if (isOnline) {
      print('Internet back. Attempting sync...');
      await userRepo.syncUsers();
    }
  });
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
