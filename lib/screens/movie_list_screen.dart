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
    return Scaffold(
      appBar: AppBar(title: const Text("Movies")),
      body: PaginatedListView<Movie>(
        fetchPage: sl<MovieService>().fetchMovies,
        itemBuilder: (movie) {
          return _MovieTile(movie: movie, userId: userId);
        },
      ),
    );
  }
}

class _MovieTile extends StatefulWidget {
  final Movie movie;
  final String userId;

  const _MovieTile({required this.movie, required this.userId});

  @override
  State<_MovieTile> createState() => _MovieTileState();
}

class _MovieTileState extends State<_MovieTile> {
  final repo = sl<BookmarkRepository>();
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final res = await repo.isBookmarked(widget.userId, widget.movie.id);
    setState(() => isSaved = res);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: widget.movie.posterUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.movie.posterUrl,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(Icons.image),
        title: Text(widget.movie.title),
        trailing: IconButton(
          icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
          onPressed: () async {
            setState(() => isSaved = !isSaved);

            await repo.toggleBookmark(
              userId: widget.userId,
              movieId: widget.movie.id,
              title: widget.movie.title,
              poster: widget.movie.posterUrl,
            );
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailScreen(movieId: widget.movie.id),
            ),
          );
        },
      ),
    );
  }
}
