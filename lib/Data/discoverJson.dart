import 'dart:convert';
import 'package:http/http.dart' as http;

class Search {
  final int id;
  final String title;
  final String overview;
  final String posterPath;

  Search({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
  });

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
    );
  }


  Future<List> searchResults(String query) async {
    final String apiKey = 'fef5ba37a530f6cc1f8e697ba4e1ef96';
    final String url = 'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query';

    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> results = jsonDecode(response.body)['results'];
      var searchResults = results.map((result) {
        return Search.fromJson(result);
      }).toList();

      return results;
      // Parse the JSON response and do something with it
      print(response.body);
    } else {
      // Handle error
      throw Exception("Failed to fetch data");
    }
  }
}