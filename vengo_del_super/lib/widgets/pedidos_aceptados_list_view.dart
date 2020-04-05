import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vengo_del_super/screens/confirmar_pedido_screen.dart';
import 'package:vengo_del_super/services/auth.dart';
import 'package:vengo_del_super/services/database.dart';

class PedidosAceptadosListView extends StatelessWidget {
  const PedidosAceptadosListView({this.snapshot});

  final snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: snapshot.data.documents
            .where((DocumentSnapshot document) =>
                document['repartidor'] ==
                Provider.of<AuthService>(context, listen: false).uid)
            .toList()
            .map<Widget>((DocumentSnapshot document) => InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ConfirmarPedidoScreen(
                          pedidoId: document.documentID,
                          userId: document.data['usuario'],
                          distancia: 0),
                    ),
                  ),
                  child: ListTile(
                    key: ValueKey(document.documentID),
                    title: FutureBuilder(
                      future:
                          Provider.of<DatabaseService>(context, listen: false)
                              .userMap(document['usuario']),
                      builder: (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? Center(child: CircularProgressIndicator())
                              : Text(snapshot.data.nombre),
                    ),
                    subtitle: Text(document['localizacion']['direccion']),
                  ),
                ))
            .toList());
  }
}
