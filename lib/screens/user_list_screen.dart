import 'package:flutter/material.dart';
import 'package:movie_hub/core/di/service_locator.dart';
import 'package:movie_hub/models/user.dart';
import 'package:movie_hub/screens/add_user_screen.dart';
import 'package:movie_hub/screens/movie_list_screen.dart';
import 'package:movie_hub/services/users/user_repository.dart';
import 'package:movie_hub/widgets/paginated_listview.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = sl<UserRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text("Users")),

      body: PaginatedListView<User>(
        fetchPage: (page) => repo.getUsers(page),
        itemBuilder: (user) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.avatar),
            ),
            title: Text('${user.firstName} ${user.lastName}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MovieListScreen(),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddUserScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}