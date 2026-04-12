class ApiConfig {
  static const baseUrl = 'https://api.themoviedb.org/3';

  static const defaultHeaders = {'Content-Type': 'application/json'};

  static Map<String, dynamic> defaultQuery = {
    'reqres_key': 'reqres_c60cdc7d9286408eb96357b3f1c82550',
    'tmdb_key': 'd8e48cbc4c3769dd4169d88844f811e4',
  };
}
