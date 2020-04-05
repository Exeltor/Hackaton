import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vengo_del_super/screens/confirmar_pedido_screen.dart';
import 'package:vengo_del_super/services/auth.dart';
import 'package:vengo_del_super/services/database.dart';
import 'package:vengo_del_super/widgets/drawer.dart';

class PedidosActivosScreen extends StatefulWidget {
  static const routeName = "/pedidos-activos";

  @override
  _PedidosActivosScreenState createState() => _PedidosActivosScreenState();
}

class _PedidosActivosScreenState extends State<PedidosActivosScreen> {
  _buildSinCoger(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
    return ListView(
        children: snapshot.data.documents
            .where((DocumentSnapshot document) =>
                document['usuario'] == Provider.of<AuthService>(context).uid &&
                document['repartidor'] == null)
            .toList()
            .map((DocumentSnapshot document) => InkWell(
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
                      future: Provider.of<DatabaseService>(context)
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

  _buildCogidos(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
    return ListView(
        children: snapshot.data.documents
            .where((DocumentSnapshot document) =>
                document['usuario'] == Provider.of<AuthService>(context).uid &&
                document['repartidor'] != null)
            .toList()
            .map((DocumentSnapshot document) => InkWell(
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
                      future: Provider.of<DatabaseService>(context)
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

  _buildAceptados(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
    return ListView(
        children: snapshot.data.documents
            .where((DocumentSnapshot document) =>
                document['repartidor'] == Provider.of<AuthService>(context).uid)
            .toList()
            .map((DocumentSnapshot document) => InkWell(
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
                      future: Provider.of<DatabaseService>(context)
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('Pedidos Activos'),
          bottom: TabBar(tabs: [
            Tab(child: Text('Sin coger')),
            Tab(
              child: Text('Cogidos'),
            ),
            Tab(child: Text('Aceptados')),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            Column(
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
                          child: _buildSinCoger(snapshot, context),
                        );
                    }
                  },
                ),
              ],
            ),
            Column(
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
                          child: _buildCogidos(snapshot, context),
                        );
                    }
                  },
                ),
              ],
            ),
            Column(
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
                          child: _buildAceptados(snapshot, context),
                        );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
