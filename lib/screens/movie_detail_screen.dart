import 'package:flutter/material.dart';
import 'package:movie_hub/core/di/service_locator.dart';
import 'package:movie_hub/models/movie.dart';
import 'package:movie_hub/services/movies/movie_service.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final movieService = sl<MovieService>();

  Movie? movie;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final res = await movieService.fetchMovieDetail(widget.movieId);

    setState(() {
      movie = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (movie == null) {
      return const Scaffold(
        body: Center(child: Text("Failed to load movie")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(movie!.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Poster
            Image.network(
              movie!.posterUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const SizedBox(height: 300, child: Icon(Icons.image)),
            ),

            const SizedBox(height: 16),

            /// 🔹 Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                movie!.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// 🔹 Release Date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Release: ${movie!.releaseDate}",
                style: const TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                movie!.overview,
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}