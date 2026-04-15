import 'package:flutter/material.dart';
import 'package:movie_hub/core/di/service_locator.dart';
import 'package:movie_hub/services/users/user_repository.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final nameCtrl = TextEditingController();
  final jobCtrl = TextEditingController();

  final repo = sl<UserRepository>();

  bool loading = false;

  Future<void> submit() async {
    final name = nameCtrl.text.trim();
    final job = jobCtrl.text.trim();
    if (name.isEmpty || job.isEmpty) return;

    setState(() => loading = true);
    await repo.addUser(name: name, job: job);
    if (!mounted) return;
    setState(() => loading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Saved locally. Syncing...')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add User')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: jobCtrl,
              decoration: const InputDecoration(labelText: 'Job'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : submit,
              child: Text(loading ? 'Creating...' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }
}
