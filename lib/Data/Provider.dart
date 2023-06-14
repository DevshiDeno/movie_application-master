import 'package:flutter/cupertino.dart';
class FavoriteMoviesProvider extends ChangeNotifier {
  List<Movie> _favoriteMovies = [];

  List<Movie> get favoriteMovies => _favoriteMovies;

  void addFavoriteMovie(Movie movie) {
    _favoriteMovies.add(movie);
    notifyListeners();
  }

  void removeFavoriteMovie(Movie movie) {
    _favoriteMovies.remove(movie);
    notifyListeners();
  }
}

class Movie {
  final int id;
  final String title;
  final String posterPath;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
  });
}