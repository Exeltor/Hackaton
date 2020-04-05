import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vengo_del_super/services/database.dart';
import 'package:vengo_del_super/widgets/pedidos_aceptados_list_view.dart';

class TabPedidosAceptados extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
          stream: Provider.of<DatabaseService>(context, listen: false)
              .listasCompra,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Cargando...');
              default:
                return Expanded(
                  child: PedidosAceptadosListView(snapshot: snapshot),
                );
            }
          },
        ),
      ],
    );
  }
}