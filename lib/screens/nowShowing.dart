import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Data/Provider.dart';
import 'detailScreen.dart';

class NowShowing extends StatefulWidget {
  NowShowing({Key? key, required this.showing}) : super(key: key);

  final List showing;

  @override
  State<NowShowing> createState() => _NowShowingState();
}

class _NowShowingState extends State<NowShowing> {
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
                  'Now Playing',
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
            itemCount: widget.showing.length,
            itemBuilder: (context, index) {
              final movie = Movie(
                id: widget.showing[index]['id'],
                title: widget.showing[index]['title'],
                posterPath:
                "https://image.tmdb.org/t/p/w500${widget.showing[index]['poster_path']}",
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
                      widget.showing[index]['id']),
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

                              if (provider.favoriteMovies.contains(movie)) {
                                provider.removeFavoriteMovie(movie);
                                setState(() {
                                  isFavorite = false;
                                });
                              } else {
                                provider.addFavoriteMovie(movie);
                                setState(() {
                                  isFavorite = true;
                                });
                              }
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