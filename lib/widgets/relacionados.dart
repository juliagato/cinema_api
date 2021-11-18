// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_if_null_operators

import 'package:flutter/material.dart';
import '../movie.dart';

class Relacionados extends StatelessWidget {
  final List similarList;

  const Relacionados({Key? key, required this.similarList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var context2 = context;
    return Container(
        // padding: EdgeInsets.all(10),
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          height: 250,
          child: ListView.builder(
              itemCount: similarList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyMovie(id: similarList[index]['id'])),
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
                                          similarList[index]['poster_path']))),
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
