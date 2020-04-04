import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vengo_del_super/models/userData.dart';
import 'package:vengo_del_super/services/database.dart';

class HacerCompraScreen extends StatelessWidget {
  static const routeName = "/hacer-compra";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayuda a alguien con su compra'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            Provider.of<DatabaseService>(context, listen: false).listasCompra,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Cargando...');
            default:
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document)  {
                  return ListTile(
                    title: FutureBuilder(
                      future: Provider.of<DatabaseService>(context).userMap(document['usuario']),
                      builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting ? CircularProgressIndicator() : Text(snapshot.data.nombre),
                    ),
                    subtitle: Text(document['localizacion']['direccion']),
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}

// Provider.of<DatabaseService>(context).userMap(document['usuario'])
