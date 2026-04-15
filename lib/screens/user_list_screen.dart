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
      appBar: AppBar(title: const Text("Exciting people !!"), centerTitle: true, backgroundColor: const Color.fromARGB(82, 230, 230, 230),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
        child: PaginatedListView<User>(
          fetchPage: (page) => repo.getUsers(page),
          itemBuilder: (user) {
            return ListTile(
              dense: false,
              minTileHeight: 80,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.avatar),
              ),
              title: Text('${user.firstName} ${user.lastName}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieListScreen(userId: user.id.toString(),),
                  ),
                );
                (context as Element).markNeedsBuild();
              },
            );
          },
        ),
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