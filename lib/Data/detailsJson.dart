import 'dart:convert';

import 'package:http/http.dart' as http;


class TmdbApi {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = 'fef5ba37a530f6cc1f8e697ba4e1ef96';

  static Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final response = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey&language=en-US'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}