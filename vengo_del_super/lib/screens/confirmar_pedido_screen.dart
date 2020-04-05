import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vengo_del_super/screens/map_screen.dart';
import 'package:vengo_del_super/services/auth.dart';

class ConfirmarPedidoScreen extends StatefulWidget {
  final userId, pedidoId, distancia;
  ConfirmarPedidoScreen({this.userId, this.pedidoId, this.distancia});

  @override
  _ConfirmarPedidoScreenState createState() => _ConfirmarPedidoScreenState();
}

class _ConfirmarPedidoScreenState extends State<ConfirmarPedidoScreen> {
  bool aceptado = false;
  Stream<DocumentSnapshot> pedidoStream;
  Future<DocumentSnapshot> userFuture;
  Firestore _firestore = Firestore.instance;
  LatLng localizacion;

  openMap(double lat, double lon) {}

  @override
  void initState() { 
    super.initState();
    pedidoStream = _firestore.document('listasDeCompra/${widget.pedidoId}').snapshots();
    userFuture = _firestore.document('users/${widget.userId}').get();
    _initAceptado();
  }

  _initAceptado() async {
    DocumentSnapshot doc = await pedidoStream.first;
    if(doc['repartidor'] != null) {
      setState(() {
        aceptado = true;
      });
    } else {
      print('no hay repartidor bro');
    }
    localizacion = LatLng(doc['localizacion']['geolocalizacion']['lat'], doc['localizacion']['geolocalizacion']['lng']);
  }

  _aceptarPedido() {
    final userId = Provider.of<AuthService>(context, listen: false).uid;
    _firestore.document('listasDeCompra/${widget.pedidoId}').updateData({'repartidor': userId}).then((reponse) {
      setState(() {
        aceptado = true;
      });
    }).catchError((error) {
      print(error);
    });
  }

  _abrirMapa() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen(geolocation: localizacion, fromConfirmar: true,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmar pedido'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Card(
              child: StreamBuilder<DocumentSnapshot>(
                stream: pedidoStream,
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text('Cargando...');
                    default:
                      return ListView(
                        children: snapshot.data['articulos']
                            .map<Widget>((articulo) => ListTile(
                                  title: Text(articulo['nombre']),
                                ))
                            .toList(),
                      );
                  }
                },
              ),
            ),
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                child: Text('Ubicación de la entrega'),
                onPressed: _abrirMapa,
              ),
              RaisedButton(
                  child: Text('Datos del destinatario'),
                  onPressed: !aceptado ? null : () {})
            ],
          ),
          if (!aceptado)
            RaisedButton(
              child: Text('Aceptar pedido'),
              onPressed: () {
              setState(() {
                _aceptarPedido();
              });
              },
            ),
        ],
      ),
    );
  }
}
