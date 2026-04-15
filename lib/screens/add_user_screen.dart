import 'package:flutter/material.dart';
import 'package:movie_hub/core/di/service_locator.dart';
import 'package:movie_hub/services/users/user_api_service.dart';
import 'package:movie_hub/services/users/user_repository.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _nameCtrl = TextEditingController();
  final _jobCtrl = TextEditingController();

  final userService = sl<UserApiService>();

  bool loading = false;

  Future<void> submit() async {
    final name = _nameCtrl.text.trim();
    final job = _jobCtrl.text.trim();

    if (name.isEmpty || job.isEmpty) return;

    setState(() => loading = true);
    //Storing in Db and Remote then syncing with server
    final repo = sl<UserRepository>();
    await repo.addUser(name: name, job: job);
    final res = await userService.createUser(name: name, job: job);

    setState(() => loading = false);

    if (res != null) {
      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User created')));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to create user')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add User")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _jobCtrl,
              decoration: const InputDecoration(labelText: "Job"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : submit,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Create User"),
            ),
          ],
        ),
      ),
    );
  }
}
