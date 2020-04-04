import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:vengo_del_super/screens/map_screen.dart';
import 'package:vengo_del_super/services/database.dart';
import 'package:great_circle_distance2/great_circle_distance2.dart';

class ListadeListasScreen extends StatefulWidget {
  static const routeName = "/lista-listas";

  @override
  _ListadeListasScreenState createState() => _ListadeListasScreenState();
}

class _ListadeListasScreenState extends State<ListadeListasScreen> {
  LatLng _tiendaElegida;
  LatLng myLoc;
  abrirMapa() async {
    var location;
    if(myLoc == null) {
      location = await Location().getLocation();
      myLoc = LatLng(location.latitude, location.longitude);
    }
    _tiendaElegida = await Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) =>
            MapScreen(myLoc)));
  }

  calculateDistance(double lat, double lon) {
    return GreatCircleDistance.fromDegrees(
            latitude1: lat,
            longitude1: lon,
            latitude2: _tiendaElegida.latitude,
            longitude2: _tiendaElegida.longitude)
        .haversineDistance();
  }

  String distanceTo(double lat, double lon) {
    return calculateDistance(lat, lon).toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayuda a alguien con su compra'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: abrirMapa,
            child: Text(
              'Abrir Mapa',
              style: TextStyle(color: Colors.white),
            ),
            color: Theme.of(context).accentColor,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Provider.of<DatabaseService>(context, listen: false)
                .listasCompra,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Cargando...');
                default:
                  return Expanded(
                    child: ListView(
                        children: snapshot.data.documents
                            .where((DocumentSnapshot document) =>
                                calculateDistance(
                                    document['localizacion']['geolocalizacion']
                                        ['lat'],
                                    document['localizacion']['geolocalizacion']
                                        ['lng']) <
                                10000)
                            .toList()
                            .map((DocumentSnapshot document) => ListTile(
                                  key: ValueKey(document.documentID),
                                  title: FutureBuilder(
                                    future:
                                        Provider.of<DatabaseService>(context)
                                            .userMap(document['usuario']),
                                    builder: (context, snapshot) => snapshot
                                                .connectionState ==
                                            ConnectionState.waiting
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : Text(snapshot.data.nombre),
                                  ),
                                  subtitle: Text(
                                      document['localizacion']['direccion']),
                                  trailing: Text(
                                      '${distanceTo(document['localizacion']['geolocalizacion']['lat'], document['localizacion']['geolocalizacion']['lng'])} metros'),
                                ))
                            .toList()),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
