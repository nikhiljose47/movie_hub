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
    final m = widget.movie;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MovieDetailScreen(movieId: m.id)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: m.posterUrl.isNotEmpty
                  ? Image.network(
                      m.posterUrl,
                      width: 70,
                      height: 90,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 70,
                      height: 90,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.movie),
                    ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    m.releaseDate,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),

            IconButton(
              icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
              onPressed: () async {
                setState(() => isSaved = !isSaved);

                await repo.toggleBookmark(
                  userId: widget.userId,
                  movieId: m.id,
                  title: m.title,
                  poster: m.posterUrl,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
