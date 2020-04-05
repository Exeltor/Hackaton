import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vengo_del_super/screens/map_screen.dart';
import 'package:vengo_del_super/services/auth.dart';
import 'package:vengo_del_super/widgets/confirmar_pedido_list_view.dart';
import 'package:vengo_del_super/widgets/user_data_bottom_sheet_content.dart';

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
  Map localizacionCompleta;
  Map destino;

  openMap(double lat, double lon) {}

  @override
  void initState() {
    super.initState();
    pedidoStream =
        _firestore.document('listasDeCompra/${widget.pedidoId}').snapshots();
    userFuture = _firestore.document('users/${widget.userId}').get();
    _initAceptado();
  }

  _initAceptado() async {
    DocumentSnapshot doc = await pedidoStream.first;
    if (doc['repartidor'] != null) {
      setState(() {
        aceptado = true;
      });
    }
    destino = doc['localizacion'];
    localizacion = LatLng(doc['localizacion']['geolocalizacion']['lat'],
        doc['localizacion']['geolocalizacion']['lng']);

    localizacionCompleta = doc['localizacion'];
  }

  _aceptarPedido() {
    final userId = Provider.of<AuthService>(context, listen: false).uid;
    _firestore
        .document('listasDeCompra/${widget.pedidoId}')
        .updateData({'repartidor': userId}).then((reponse) {
      setState(() {
        aceptado = true;
      });
    }).catchError((error) {
      print(error);
    });
  }

  _abrirMapa() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MapScreen(
              geolocation: localizacion,
              fromConfirmar: true,
            )));
  }

  _flipComprado(oldArt, newArt) {
    _firestore.document('listasDeCompra/${widget.pedidoId}').updateData({
      'articulos': FieldValue.arrayRemove([oldArt])
    }).then((success) {
      _firestore.document('listasDeCompra/${widget.pedidoId}').updateData({
        'articulos': FieldValue.arrayUnion([newArt])
      });
    });
  }

  _showBottomSheet() async {
    var destinatario = await userFuture;
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Color(0xFF737373),
        height: 300,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: UserDataBottomSheetContent(
              localizacionCompleta: localizacionCompleta,
              destinatario: destinatario,
            ),
          ),
        ),
      ),
    );
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
                      var articulos = snapshot.data['articulos'];
                      return ConfirmarPedidoListView(articulos: articulos, aceptado: aceptado, flipComprado: _flipComprado);
                  }
                },
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  child: Text(
                    'Ubicación de la entrega',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _abrirMapa,
                ),
              ),
              if (aceptado)
                Expanded(
                  child: FlatButton(
                    child: Text(
                      'Datos del destinatario',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _showBottomSheet,
                  ),
                )
            ],
          ),
          if (!aceptado)
            ButtonTheme(
              height: 50,
              child: RaisedButton(
                child: Text(
                  'Aceptar pedido',
                  style: TextStyle(color: Theme.of(context).canvasColor),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                color: Theme.of(context).accentColor,
                onPressed: () {
                  setState(() {
                    _aceptarPedido();
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
