import 'package:flutter/material.dart';
import 'package:movie_hub/core/di/service_locator.dart';
import 'package:movie_hub/models/movie.dart';
import 'package:movie_hub/screens/movie_detail_screen.dart';
import 'package:movie_hub/services/movies/movie_service.dart';
import 'package:movie_hub/widgets/paginated_listview.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieService = sl<MovieService>();

    return Scaffold(
      appBar: AppBar(title: const Text("Trending Movies")),
      body: PaginatedListView<Movie>(
        fetchPage: movieService.fetchMovies,
        itemBuilder: (movie) {
          return ListTile(
            leading: Image.network(
              movie.posterUrl,
              width: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported),
            ),
            title: Text(movie.title),
            subtitle: Text(movie.releaseDate),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailScreen(movieId: movie.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}