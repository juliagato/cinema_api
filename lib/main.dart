// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, unused_import

import 'package:cinema_api/widgets/lancamentos.dart';
import 'package:cinema_api/widgets/series.dart';
import 'widgets/trending.dart';
import 'package:flutter/material.dart';
import 'movie.dart';
import 'sobre.dart';
import 'liked.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'dart:ui' show lerpDouble;

void main() {
  runApp(const CinemaApi());
}

class CinemaApi extends StatelessWidget {
  const CinemaApi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cinema API',
      theme: ThemeData(
        primaryColor: Colors.grey.shade400,
        canvasColor: Colors.grey.shade100,
      ),
      home: const HomePage(title: 'Homepage'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List movies = [];
  List tv = [];
  List trending = [];
  final apiKey = '4b1780ead5381b8451622529f1069939';
  final accessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0YjE3ODBlYWQ1MzgxYjg0NTE2MjI1MjlmMTA2OTkzOSIsInN1YiI6IjYxODVhZGIxM2ZhYmEwMDAyYzQ1ODlmMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.c_t2SlVtPlKu7ac95EWMjIDYyl8rNjF44o6AP0T8Vm0';

  @override
  void initState() {
    loadMovies();
    super.initState();
  }

  loadMovies() async {
    TMDB tmdbLogs = TMDB(ApiKeys(apiKey, accessToken),
        logConfig: ConfigLogger(showLogs: true, showErrorLogs: true));

    Map movieResults = await tmdbLogs.v3.movies.getTopRated();
    Map trendingResults = await tmdbLogs.v3.trending.getTrending();
    Map tvResults = await tmdbLogs.v3.tv.getPouplar();

    setState(() {
      movies = movieResults['results'];
      trending = trendingResults['results'];
      tv = tvResults['results'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOOKIE',
            style: TextStyle(
                fontFamily: 'Lemon Milk', color: Colors.black, fontSize: 20)),
        backgroundColor: Colors.grey.shade500,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Início"),
              subtitle: Text("Confira os filmes e catálogos"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CinemaApi()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Minha lista"),
              subtitle: Text("Confira os seus curtidos"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Liked()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text("Sobre nós"),
              subtitle: Text("Conheça o grupo"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Sobre()),
                );
              },
            )
          ],
        ),
      ),
      body: ListView(
        children: [
          Lancamentos(moviesList: movies),
          Series(tvList: tv),
          Trendings(trendingList: trending)
        ],
      ),
    );
  }
}
