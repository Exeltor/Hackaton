import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vengo_del_super/providers/compraService.dart';
import 'package:vengo_del_super/widgets/review_lista_compra.dart';

import 'home_screen.dart';

class ConfirmarCompraScreen extends StatelessWidget {
  static const routeName = '/confirmar-compra';

  void _finalizar(BuildContext context) {
    Provider.of<CompraService>(context, listen: false).crearListaDeCompra();
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirma todos los datos'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Consumer<CompraService>(
              builder: (context, data, staticChild) => Column(
                children: <Widget>[
                  Flexible(
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Tu lista de compra',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(),
                          Expanded(
                            child: ReviewListaCompra(data.listaDeCompra),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Tu direccion',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Divider(),
                            Text(
                              'Direccion',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data.direccionCompleta['direccionEntrega'],
                              softWrap: true,
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Column(
                                  children: <Widget>[
                                    Text(
                                      'Bloque/Piso',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      data.direccionCompleta['piso'] == ''
                                          ? 'N/A'
                                          : data.direccionCompleta['piso'],
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      'Puerta',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      data.direccionCompleta['puerta'] == ''
                                          ? 'N/A'
                                          : data.direccionCompleta['piso'],
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Container(
                                child: Image.network(
                                  data.direccionCompleta['imagen'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            color: Theme.of(context).accentColor,
            child: InkWell(
              child: Center(
                child: Text(
                  'Finalizar',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              onTap: () => _finalizar(context)
            ),
          )
        ],
      ),
    );
  }
}
