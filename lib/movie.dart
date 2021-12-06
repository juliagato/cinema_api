// ignore_for_file: unused_import, import_of_legacy_library_into_null_safe, prefer_final_fields, prefer_const_constructors
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:cinema_api/widgets/relacionados.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MyMovie extends StatefulWidget {
  final int id;

  const MyMovie({Key? key, required this.id}) : super(key: key);

  @override
  _MyMovieState createState() => _MyMovieState();
}

class _MyMovieState extends State<MyMovie> {
  //PASSO 2 - INSTANCIAR O BANCO FIREBASE
  var dbfb = FirebaseFirestore.instance;

  String _titulo = "";
  String _sinopse = "";
  String _lancamento = "";
  String _descricao = "";
  String _poster = "";
  String _atores = "";
  String _nota = "";
  bool liked = false;
  List _similares = [];
  final apiKey = '4b1780ead5381b8451622529f1069939';
  final accessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0YjE3ODBlYWQ1MzgxYjg0NTE2MjI1MjlmMTA2OTkzOSIsInN1YiI6IjYxODVhZGIxM2ZhYmEwMDAyYzQ1ODlmMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.c_t2SlVtPlKu7ac95EWMjIDYyl8rNjF44o6AP0T8Vm0';

  late StreamSubscription<QuerySnapshot> strSubPalavra;
  @override
  void initState() {
    _recuperar();
    super.initState();
  }

  _recuperar() async {
    TMDB tmdbLogs = TMDB(ApiKeys(apiKey, accessToken),
        logConfig: ConfigLogger(showLogs: true, showErrorLogs: true));
    Map details =
        await tmdbLogs.v3.movies.getDetails(widget.id, language: 'pt-BR');
    Map similar =
        await tmdbLogs.v3.movies.getSimilar(widget.id, language: 'pt-BR');

    Map credits = await tmdbLogs.v3.movies.getCredits(widget.id);
    credits["cast"]
        .removeWhere((element) => element["known_for_department"] != "Acting");

    String actors = "";
    for (var i = 0; i < credits["cast"].length; i++) {
      if (i == 0)
        actors += credits["cast"][i]["name"];
      else
        actors += ", " + credits["cast"][i]["name"];

      if (i == 10) i == credits["cast"].length + 1;
    }
    strSubPalavra = dbfb
        .collection("liked")
        .where("id", isEqualTo: widget.id)
        .snapshots()
        .listen((snapshot) {
      int fav = snapshot.docs.length;
      setState(() {
        liked = fav == 0 ? false : true;
      });
    });

    setState(() {
      _titulo = details["title"];
      _sinopse = details["overview"];
      _lancamento = details["release_date"];
      _nota = details["vote_average"].toString();
      _poster = details["poster_path"];
      _atores = actors;
      _similares = similar["results"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOBRE',
            style: TextStyle(
                fontFamily: 'Lemon Milk', color: Colors.black, fontSize: 20)),
        backgroundColor: Colors.grey.shade500,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
            //physics: NeverScrollableScrollPhysics(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: 137,
                    height: 201,
                    margin: const EdgeInsets.only(right: 20.0),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500' + _poster,
                    )))),
                Expanded(
                    child: Column(
                        //mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      Text(
                        _titulo,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: 'Estréia: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black),
                          children: [
                            TextSpan(
                                text: _lancamento,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: 'Nota: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black),
                          children: [
                            TextSpan(
                                text: _nota,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            dbfb.collection("liked").add({
                              "id": widget.id,
                              "poster_path": _poster,
                            });
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            //backgroundColor: Colors.pinkAccent[50],
                          ),
                          // child: const Text(
                          //   "  Gravar  ",
                          //   style: TextStyle(fontSize: 20.0),
                          // )),
                          child: Icon(
                            !liked
                                ? Icons.favorite_border_outlined
                                : Icons.favorite,
                            color: Colors.pink,
                            size: 24.0,
                          )),
                    ]))
              ]),
          SizedBox(
            height: 10,
          ),
          Text(
            "Sinopse",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(
            _sinopse,
            style: TextStyle(fontSize: 13),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Atores principais",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(
            _atores,
            style: TextStyle(fontSize: 13),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Filmes relacionados",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Relacionados(similarList: _similares),
        ])),
      ),
    );
  }
}
