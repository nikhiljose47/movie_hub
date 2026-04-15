import 'package:flutter/material.dart';
import 'package:movie_hub/core/di/service_locator.dart';
import 'package:movie_hub/models/user.dart';
import 'package:movie_hub/screens/add_user_screen.dart';
import 'package:movie_hub/screens/movie_list_screen.dart';
import 'package:movie_hub/services/users/user_repository.dart';
import 'package:movie_hub/widgets/paginated_listview.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final repo = sl<UserRepository>();

  int refreshKey = 0;

  void refresh() {
    setState(() => refreshKey++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exciting people !!"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(82, 230, 230, 230),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        child: PaginatedListView<User>(
          key: ValueKey(refreshKey),
          fetchPage: (page) => repo.getUsers(page),
          itemBuilder: (user) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: user.avatar.isNotEmpty
                    ? NetworkImage(user.avatar)
                    : null,
                child: user.avatar.isEmpty
                    ? const Icon(Icons.person, size: 28, color: Colors.white)
                    : null,
              ),
              title: Text(
                '${user.firstName} ${user.lastName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieListScreen(userId: user.id),
                  ),
                );
                refresh();
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddUserScreen()),
          );
          refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
