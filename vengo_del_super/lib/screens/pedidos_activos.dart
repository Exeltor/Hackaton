import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:vengo_del_super/widgets/drawer.dart';
import 'package:vengo_del_super/widgets/tab_pedidos_aceptados.dart';
import 'package:vengo_del_super/widgets/tab_pedidos_cogidos.dart';
import 'package:vengo_del_super/widgets/tab_pedidos_sin_coger.dart';

class PedidosActivosScreen extends StatelessWidget {
  static const routeName = "/pedidos-activos";

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
            TabPedidosSinCoger(),
            TabPedidosCogidos(),
            TabPedidosAceptados(),
          ],
        ),
      ),
    );
  }
}