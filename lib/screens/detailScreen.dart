import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_project/Data/detailsJson.dart';
import 'package:video_player/video_player.dart';

import 'actors.dart';

class DetailScreen extends StatefulWidget {
  final int movieId;
  const DetailScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final List<Actor>actors;

  late Future<Map<String, dynamic>> _futureMovie;
  late final int movieId;
  late Future<List<Actor>> _actorsFuture;


  Future<List<Actor>> fetchActors(int movieId) async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/$movieId/credits?api_key=fef5ba37a530f6cc1f8e697ba4e1ef96'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> cast = data['cast'];

      return cast.map((actor) => Actor(
        name: actor['name'],
        imageUrl: 'https://image.tmdb.org/t/p/w500${actor['profile_path']}',
      )).toList();
    } else {
      throw Exception('Failed to load actors');
    }
  }


  @override
  void initState() {
    super.initState();
    _actorsFuture = fetchActors(widget.movieId);
    _futureMovie = TmdbApi.getMovieDetails(widget.movieId);
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 16),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: AppBar(
            elevation: 0,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Positioned(
                left: 24,
                top: 18,
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            title: const Center(
              child: Text("WATCH", style: TextStyle(color: Colors.black)),
            ),
            actions: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Positioned(
                  left: 327,
                  top: 18,
                  child: Icon(Icons.notifications_none_rounded,
                      color: Colors.black),
                ),
              ),
            ],
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _futureMovie,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final movie = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8), bottom: Radius.circular(8)),
                    child: Image(
                      image: NetworkImage(
                          'https://image.tmdb.org/t/p/w780${movie['backdrop_path']}'),
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              buildTitle(context),
                              buildRow(context),
                              SizedBox(
                                height: 50,
                              ),

                              buildSizedBox(context),
                              SizedBox(
                                height: 50,
                              ),

                              buildContainerActors(),
                            ])),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load movie details'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return FutureBuilder(
        future: _futureMovie,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final movie = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    movie['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Muli-Bold',
                      fontSize: 20,
                      height: 1.3,
                      // line height of 23pt
                      letterSpacing: 0.4,
                    ),
                    maxLines: null, // to allow multiple lines
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                    icon: const Icon(
                      Icons.star,
                      size: 15,
                      color: Colors.yellowAccent,
                    ),
                    label: const Text("6.5/10"),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      textStyle: const TextStyle(fontSize: 12),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        //width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Horror',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 10,
                            letterSpacing: 0.02,
                            color: Color(0xFFAAA9B1),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // child:  Text(
                        //   movie["genre"],
                        //   style: TextStyle(
                        //     fontFamily: 'Mulish',
                        //     fontSize: 10,
                        //     letterSpacing: 0.02,
                        //     color: Color(0xFFAAA9B1),
                        //   ),
                        // ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Thriller',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 10,
                            letterSpacing: 0.02,
                            color: Color(0xFFAAA9B1),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load movie details'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget buildRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          // padding:
          // const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: 120,
          height: 50,
          //color: Colors.white,
          child: ListTile(
            title: Text("Length"),
            subtitle: Text("2h 30min"),
          ),
        ),
        Container(
          // padding:
          // const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: 120,
          height: 50,
          // color: Colors.white,
          child: const ListTile(
            title: Text("Language"),
            subtitle: Text("2hrs 30min"),
          ),
        ),
        Container(
          // padding:
          // const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: 120,
          height: 50,
          //color: Colors.white,
          child: const ListTile(
            title: Text("Rating"),
            subtitle: Text("PG-13"),
          ),
        ),
      ],
    );
  }

  Widget buildSizedBox(BuildContext context) {
    return FutureBuilder(
        future: _futureMovie,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final movie = snapshot.data!;
            return ListTile(
              title: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Description',
                  style: TextStyle(
                    color: Color.fromRGBO(17, 14, 71, 1),
                    fontFamily: 'Merriweather-Black',
                    fontSize: 16,
                    letterSpacing: 0.32,
                    height: 1.0,
                  ),
                ),
              ),
              subtitle: Text(
                movie['overview'],
                style: TextStyle(
                  color: Color.fromRGBO(156, 156, 156, 1),
                  fontFamily: 'Muli-Regular',
                  fontSize: 12,
                  letterSpacing: 0.24,
                  height: 1.56,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load movie details'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }



  Widget buildContainerActors() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text(
                    "Cast",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          buildActorCards()
        ],
      ),
    );
  }

  Widget buildActorCards() {
    return FutureBuilder(
        future: _actorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final actors = snapshot.data!;
            return SizedBox(
              height: 200,
              child: Container(
                color: Colors.white24,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: actors.length,
                  itemBuilder: ( context, int index) {
                    final actor =actors[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 12, top: 0, right: 12, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                                bottom: Radius.circular(8)),
                            child: Image(
                                image: NetworkImage(actor.imageUrl),
                                width: 143,
                                height: 106),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            actor.name,
                            style:
                            const TextStyle(
                                fontFamily: "Muli-Bold", fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }
          else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load actors'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }
}
