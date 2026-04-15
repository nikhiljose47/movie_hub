import 'package:movie_hub/core/network/dio_client.dart';
import 'package:movie_hub/models/movie.dart';

class MovieService {
  final DioClient _client;

  MovieService(this._client);

  Future<List<Movie>> fetchMovies(int page) async {
    try {
      final response = await _client.get(
        '/trending/movie/day',
        query: {'page': page},
      );

      final List results = response.data['results'] ?? [];

      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Movie?> fetchMovieDetail(int id) async {
    try {
      final response = await _client.get('/movie/$id');

      return Movie.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}
