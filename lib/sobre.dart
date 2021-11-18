// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'main.dart';

void SobreRoda() => runApp(Sobre());

class Sobre extends StatelessWidget {
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
      body: Center(
          child: Text(
              "Projeto desenvolvido por Ana Carolina Rocha, Camille Gachido,\n\nJulia Gato e Marjorye Ciardullo, no ano de 2021.",
              style: TextStyle(
                  fontFamily: 'Lemon Milk',
                  color: Colors.black,
                  fontSize: 20))),
    );
  }
}
