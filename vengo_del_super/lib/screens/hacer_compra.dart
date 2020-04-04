import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HacerCompraScreen extends StatefulWidget {
  static const routeName = "/hacer-compra";

  @override
  _HacerCompraScreen createState() => _HacerCompraScreen();
}

class _HacerCompraScreen extends State<HacerCompraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayuda a alguien con su compra'),
      ),
      body: ListaDeCompra(),
    );
  }
}

class ListaDeCompra extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('listasDeCompra').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Cargando...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['usuarioUid']),
                  subtitle: new Text(document['articulos'][0]['cantidad']),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
