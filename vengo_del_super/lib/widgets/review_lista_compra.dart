import 'package:flutter/material.dart';

class ReviewListaCompra extends StatelessWidget {
  final List<Map> listaCompra;

  ReviewListaCompra(this.listaCompra);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, i) => ListTile(
        title: Text(listaCompra[i]['nombre']),
        trailing: Column(
          children: <Widget>[
            Text('Cantidad'),
            Text(listaCompra[i]['cantidad']),
          ],
        ),
      ),
      itemCount: listaCompra.length,
    );
  }
}
