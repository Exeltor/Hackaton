import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vengo_del_super/providers/compraService.dart';

import 'customer_submit_address_screen.dart';

class ListaCompraScreen extends StatefulWidget {
  static const routeName = "/lista-compra";

  @override
  _ListaCompraScreenState createState() => _ListaCompraScreenState();
}

class _ListaCompraScreenState extends State<ListaCompraScreen> {
  List<Map> _listaCompra = [];
  final _form = GlobalKey<FormState>();
  String _articuloCompra;
  String _cantidadCompra;

  void _submitItem() {
    final isValid = _form.currentState.validate();

    if (!isValid) return;

    _form.currentState.save();

    Map<String, dynamic> articulo = {
      'nombre': _articuloCompra,
      'cantidad': _cantidadCompra,
      'comprado': false,
    };

    setState(() {
      _listaCompra.add(articulo);
    });

    _articuloCompra = null;
    _cantidadCompra = null;

    _form.currentState.reset();
  }

  void _removeItemButton(var item) {
    setState(() {
      _listaCompra.remove(item);
    });
  }

  void _reorderItems(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final item = _listaCompra.removeAt(oldIndex);
        _listaCompra.insert(newIndex, item);
      },
    );
  }

  void _nextStep() {
    if (_listaCompra.length < 1) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Comprueba tu lista'),
          content: Text('Tienes que tener al menos un articulo en tu lista de compra'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Ok',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
          ],
        ),
      );
      return;
    }

    Provider.of<CompraService>(context, listen: false).submitListaDeCompra(_listaCompra);
    Navigator.of(context).pushNamed(CustomerSubmitAddressScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Haz la lista de tu compra'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _form,
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Nombre articulo',
                          labelStyle: TextStyle()),
                      validator: (value) {
                        if (value.isEmpty) return 'Rellena este campo';
                        return null;
                      },
                      onSaved: (value) {
                        _articuloCompra = value;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Cantidad'),
                      validator: (value) {
                        if (value.isEmpty) return 'Rellena este campo';
                        return null;
                      },
                      onSaved: (value) {
                        _cantidadCompra = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          FlatButton(
            onPressed: _submitItem,
            child: Text(
              'Añadir articulo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ReorderableListView(
              onReorder: _reorderItems,
              children: _listaCompra
                  .map(
                    (item) => ListTile(
                      key: ValueKey(item),
                      title: Text(item['nombre']),
                      trailing: Container(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(item['cantidad']),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () => _removeItemButton(item),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            height: 60,
            color: Theme.of(context).accentColor,
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Siguiente',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
              onTap: _nextStep,
            ),
          )
        ],
      ),
    );
  }
}
