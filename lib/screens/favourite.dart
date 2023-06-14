import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Data/Provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteMoviesProvider>(context);
    final favoriteMovies = provider.favoriteMovies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body:ListView.builder(
        itemCount: favoriteMovies.length,
        itemBuilder: (context, index) {
          final movie = favoriteMovies[index];

          return Dismissible(
            key: Key(movie.id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              provider.removeFavoriteMovie(movie);
            },
            background: Container(
              color: Colors.red,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ),
            child: GestureDetector(
              onTap: (){
                // Navigator.push(context, MaterialPageRoute(builder:(context)=>DetailScreen( movieId: null,)));
              },
              child: ListTile(
                title: Text(movie.title),
                leading: Image.network(movie.posterPath),
              ),
            ),
          );
        },
      )
    );
  }
}