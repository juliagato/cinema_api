// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_if_null_operators

import 'package:flutter/material.dart';
import '../movie.dart';

class Favoritos extends StatelessWidget {
  final List likesList;

  const Favoritos({Key? key, required this.likesList}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Minha Lista',
                style: TextStyle(
                  fontFamily: 'Lemon Milk',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 250,
              child: ListView.builder(
                  itemCount: likesList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyMovie(id: likesList[index]['id'])),
                        );
                      },
                      child: Container(
                        width: 140,
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(9.5)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://image.tmdb.org/t/p/w500' +
                                              likesList[index]
                                                  ['poster_path']))),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
