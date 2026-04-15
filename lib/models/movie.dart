class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String releaseDate;
  final String overview;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    required this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      overview: json['overview'] ?? '',
    );
  }

  String get posterUrl {
    if (posterPath.isEmpty) {
      return '';
    }
    return 'https://image.tmdb.org/t/p/w185$posterPath';
  }
}
