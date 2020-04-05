import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final LatLng geolocation;
  final bool fromConfirmar;
  MapScreen({@required this.geolocation, this.fromConfirmar = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  @override
  void initState() {
    super.initState();
    if(widget.fromConfirmar){
      _selectPlace(widget.geolocation);
    }
  }

  void _selectPlace(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elige destino de la entrega'),
        actions: widget.fromConfirmar ? null :<Widget>[
          IconButton(icon: Icon(Icons.check), onPressed: _pickedLocation == null ? null : () => Navigator.of(context).pop(_pickedLocation))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.geolocation,
          zoom: 16,
        ),
        onTap: widget.fromConfirmar ? null : _selectPlace,
        markers: _pickedLocation == null
            ? null
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  position: _pickedLocation,
                ),
              },
      ),
    );
  }
}