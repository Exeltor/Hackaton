import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompraService with ChangeNotifier {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  List<Map> _listaDeCompra;
  String _direccionEntrega, _piso, _puerta, _previewImage;
  Map _geolocalizacion;


  submitListaDeCompra(List listaDeCompra) {
    _listaDeCompra = listaDeCompra;
  }

  submitDireccionEntrega(String direccionEntrega, String piso, String puerta, Map geolocalizacion, String previewImage) {
    _direccionEntrega = direccionEntrega;
    _piso = piso;
    _puerta = puerta;
    _geolocalizacion = geolocalizacion;
    _previewImage = previewImage;
  }

  crearListaDeCompra() async {
    final user = await _auth.currentUser();
    await _firestore.collection('listasDeCompra').document().setData({
      'articulos': _listaDeCompra,
      'usuario': user.uid,
      'localizacion': {
        'geolocalizacion': _geolocalizacion,
        'direccion': _direccionEntrega,
        'piso': _piso,
        'puerta': _puerta
      },
    });
    
    resetVariables();
  }

  resetVariables() {
    _direccionEntrega = null;
    _piso = null;
    _puerta = null;
    _geolocalizacion = null;
    _previewImage = null;
    _listaDeCompra = null;
  }

  List<Map> get listaDeCompra {
    return [..._listaDeCompra];
  }

  Map get direccionCompleta {
    return {
      'direccionEntrega': _direccionEntrega,
      'piso': _piso,
      'puerta': _puerta,
      'imagen': _previewImage,
      'geolocalizacion': _geolocalizacion
    };
  }
}