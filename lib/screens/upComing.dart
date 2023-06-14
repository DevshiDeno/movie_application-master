import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Data/Provider.dart';
import 'detailScreen.dart';

class UpComing extends StatefulWidget {
  UpComing({Key? key, required this.upcoming}) : super(key: key);

  final List upcoming;

  @override
  State<UpComing> createState() => _UpComingState();
}

class _UpComingState extends State<UpComing> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'UpComing',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 15,
                    letterSpacing: 0.02,
                    color: Colors.black,
                  ),
                ),
              ),

            ],
          ),
        ),
        Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.upcoming.length,
            itemBuilder: (context, index) {
              final movie = Movie(
                id: widget.upcoming[index]['id'],
                title: widget.upcoming[index]['title'],
                posterPath:
                "https://image.tmdb.org/t/p/w500${widget.upcoming[index]['poster_path']}",
              );

              final provider = Provider.of<FavoriteMoviesProvider>(context);
              var isFavorite = provider.favoriteMovies.contains(movie);

              return Padding(
                padding:
                const EdgeInsets.only(left: 12, top: 0, right:
                12, bottom:
                16),
                child:
                InkWell(
                  onTap:
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder:
                          (context) => DetailScreen(movieId:
                      widget.upcoming[index]['id']),
                      ),
                    );
                  },
                  child:
                  Column(children:
                  [
                    Stack(children:
                    [
                      ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(8), bottom: Radius.circular(8)),
                        child: Image(height: 200, fit: BoxFit.cover, image: NetworkImage(movie.posterPath)),
                      ),

                      Positioned(top: 0, right :0 ,
                        child:

                        IconButton(
                          icon: isFavorite ? Icon(Icons.favorite, color: Colors.red) : Icon(Icons.favorite_border, color: Colors.grey),
                          onPressed: () {
                            final provider = Provider.of<FavoriteMoviesProvider>(context, listen: false);
                             isFavorite = provider.favoriteMovies.contains(movie);

                            if (isFavorite) {
                              provider.removeFavoriteMovie(movie);
                            } else {
                              provider.addFavoriteMovie(movie);
                            }

                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                        )
                      ),
                    ],
                    ),
                  ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}