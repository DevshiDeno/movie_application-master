import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Data/discoverJson.dart';
import 'detailScreen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Search> _searchResults = [];

  Future<void> searchMovies(String query) async {
    const String apiKey = 'fef5ba37a530f6cc1f8e697ba4e1ef96';
    final String url =
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query';

    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Parse the JSON response and update the search results
      setState(() {
        final List<dynamic> results = jsonDecode(response.body)['results'];
        _searchResults =
            results.map((result) => Search.fromJson(result)).toList();
      });
    } else {
      // Handle error
      throw Exception("Failed to fetch data");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return SafeArea(
      child: Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 48,
                margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for movies',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchResults = [];
                        });
                      },
                    ),
                  ),
                  onSubmitted: (query) => searchMovies(query),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: buildContainerMovies(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContainerMovies() {
    int numColumns = 2;
    double itemWidth = MediaQuery
        .of(context)
        .size
        .width / numColumns;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: numColumns,
        childAspectRatio: 0.55, // adjust as needed
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final Search searchResult = _searchResults[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => DetailScreen(movieId:(_searchResults[index].id)),
              ),
            );
          },
          child: Container(
            width: itemWidth,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
                  child:
                  searchResult.posterPath != null
                      ? Image.network(
                    'https://image.tmdb.org/t/p/w500${searchResult.posterPath}',
                    width:
                    itemWidth, // use itemWidth instead of MediaQuery
                    height:
                    itemWidth * 1.5, // adjust as needed for aspect ratio
                    fit:
                    BoxFit.cover,
                  )
                      : Container(
                    width:
                    itemWidth, // use itemWidth instead of MediaQuery
                    height:
                    itemWidth * 1.5, // adjust as needed for aspect ratio
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    searchResult.title,
                    style:
                    const TextStyle(fontFamily: "Muli-Bold", fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}