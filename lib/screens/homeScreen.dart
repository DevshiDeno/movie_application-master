import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_project/screens/discoverscreen.dart';
import 'package:movie_project/screens/popular.dart';
import 'package:movie_project/screens/upComing.dart';
import 'package:movie_project/utils/text.dart';
import 'favourite.dart';
import 'nowShowing.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<dynamic> nowShowing = [];
  List<dynamic> popular = [];
  List<dynamic> upComing = [];

  @override
  void initState() {
    super.initState();
    fetchNowShowing();
    fetchPopular();
    fetchUpcoming();
  }
  Future fetchPopular() async {
    final response = await http.get(
      Uri.parse("https://api.themoviedb.org/3/movie/top_rated?api_key=fef5ba37a530f6cc1f8e697ba4e1ef96&language=en-US&page=1"),
    );

    if (response.statusCode == 200) {
      setState(() {
        popular = jsonDecode(response.body)["results"];
      });
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  Future fetchNowShowing() async {
    final response = await http.get(
      Uri.parse("https://api.themoviedb.org/3/movie/now_playing?api_key=fef5ba37a530f6cc1f8e697ba4e1ef96"),
    );

    if (response.statusCode == 200) {
      setState(() {
        nowShowing = jsonDecode(response.body)["results"];
      });
    } else {
      throw Exception("Failed to fetch data");
    }
  }
  Future fetchUpcoming() async {
    final response = await http.get(
      Uri.parse("https://api.themoviedb.org/3/movie/upcoming?api_key=fef5ba37a530f6cc1f8e697ba4e1ef96"),
    );

    if (response.statusCode == 200) {
      setState(() {
        upComing = jsonDecode(response.body)["results"];
      });
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 8),
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: AppBar(
            elevation: 0,
            leading: const Positioned(
              left: 24,
              top: 18,
              child: Icon(Icons.person_3_rounded, color: Colors.black),
            ),
             title: Center(child: modified_text(text: "WATCH", color: Colors.white, size: 20,)),

            actions: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => FavoriteScreen()));
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Positioned(
                    left: 327,
                    top: 18,
                    child: Icon(Icons.favorite,
                        color: Colors.deepOrange),
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DiscoverScreen()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Positioned(
                      left: 327,
                      top: 18,
                      child: Icon(Icons.search,size: 20, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
            backgroundColor: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: Colors.white24,

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NowShowing(showing:nowShowing),
              Popular(popular: popular,),
              UpComing(upcoming: upComing,)
            ],
          ),
        ),
      )
    );
  }
}


