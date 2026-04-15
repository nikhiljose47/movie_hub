import 'package:flutter/material.dart';
import 'package:movie_hub/core/di/service_locator.dart';
import 'package:movie_hub/models/movie.dart';
import 'package:movie_hub/screens/movie_detail_screen.dart';
import 'package:movie_hub/services/movies/bookmark_repository.dart';
import 'package:movie_hub/services/movies/movie_service.dart';
import 'package:movie_hub/widgets/paginated_listview.dart';

class MovieListScreen extends StatelessWidget {
  final String userId;

  const MovieListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final repo = sl<BookmarkRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text("Movies")),

      body: PaginatedListView<Movie>(
        fetchPage: sl<MovieService>().fetchMovies,
        itemBuilder: (movie) {
          return FutureBuilder<bool>(
            future: repo.isBookmarked(userId, movie.id),
            builder: (context, snapshot) {
              final isSaved = snapshot.data ?? false;

              return Container(
                margin: const EdgeInsets.only(left: 12, right: 1, bottom: 10, top: 6),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(137, 250, 250, 250),
                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: ListTile(
                  title: Text(movie.title),
                  minVerticalPadding: 8,
                  leading: movie.posterUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),

                          child: Image.network(
                            movie.posterUrl,
                            width: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image),
                          ),
                        )
                      : const Icon(Icons.image),
                  trailing: IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                    ),
                    onPressed: () async {
                      await repo.toggleBookmark(
                        userId: userId,
                        movieId: movie.id,
                        title: movie.title,
                        poster: movie.posterUrl,
                      );

                      (context as Element).markNeedsBuild();
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieDetailScreen(movieId: movie.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
