import 'package:flutter/material.dart';
import 'package:movie_project/screens/homeScreen.dart';
import 'package:movie_project/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'Data/Provider.dart';
import 'screens/detailScreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoriteMoviesProvider(),
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WATCH',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => Home(),
      },
    );
  }
}