import 'package:flutter/material.dart';

class CompraService with ChangeNotifier {
  List<Map> _listaDeCompraSubmit;

  submitListaDeCompra(List listaDeCompra) {
    _listaDeCompraSubmit = listaDeCompra;
  }

  List<Map> get listaDeCompraSubmit {
    return [..._listaDeCompraSubmit];
  }
}