// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, unused_import
import 'dart:async';
import 'package:cinema_api/widgets/favoritos.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:tmdb_api/tmdb_api.dart';
//import 'dart:ui' show lerpDouble;

void main() {
  runApp(const Liked());
}

class Liked extends StatelessWidget {
  const Liked({Key? key}) : super(key: key);

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
  List favoritos = [];
  var dbfb = FirebaseFirestore.instance;
  late StreamSubscription<QuerySnapshot> strSubPalavra;

  @override
  void initState() {
    super.initState();
    favoritos = [];
    //strSubPalavra.cancel();
    strSubPalavra =
        dbfb.collection("liked").orderBy("id").snapshots().listen((snapshot) {
      final List favs = snapshot.docs
          .map((documentSnapshot) => {
                "id": documentSnapshot.data()["id"],
                "poster_path": documentSnapshot.data()["poster_path"] ?? ""
              })
          .toList();
      setState(() {
        favoritos = favs;
      });
    });
  }

  Stream<QuerySnapshot> getPalavras() {
    return FirebaseFirestore.instance
        .collection("liked")
        .orderBy("id")
        .snapshots();
  }

  @override
  void dispose() {
    super.dispose();
    favoritos.clear();
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
      body:  ListView(
        children: [
          Favoritos(likesList: favoritos)
        ],
    ));
  }
}
