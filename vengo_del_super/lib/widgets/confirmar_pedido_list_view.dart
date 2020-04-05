import 'package:flutter/material.dart';

class ConfirmarPedidoListView extends StatelessWidget {
  const ConfirmarPedidoListView({
    @required this.articulos,
    @required this.aceptado,
    @required this.flipComprado,
    @required this.terminado
  });

  final articulos;
  final bool aceptado;
  final Function flipComprado;
  final bool terminado;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: articulos.length,
      itemBuilder: (context, i) => ListTile(
        title: Text(
          articulos[i]['nombre'],
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text('Cantidad: ${articulos[i]['cantidad']}',style: TextStyle(fontSize: 16),),
        trailing: !aceptado || terminado
            ? null
            : Checkbox(
                value: articulos[i]['comprado'],
                onChanged: (value) {
                  var oldValue = {
                    'comprado': articulos[i]['comprado'],
                    'nombre': articulos[i]['nombre'],
                    'cantidad': articulos[i]['cantidad']
                  };
                  var newValue = {
                    'comprado': value,
                    'nombre': articulos[i]['nombre'],
                    'cantidad': articulos[i]['cantidad']
                  };

                  flipComprado(oldValue, newValue);
                }),
      ),
    );
  }
}