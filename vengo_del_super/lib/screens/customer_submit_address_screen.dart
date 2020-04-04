import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:vengo_del_super/helpers/location_helper.dart';
import 'package:vengo_del_super/providers/compraService.dart';
import 'package:vengo_del_super/screens/confirmar_compra_screen.dart';

class CustomerSubmitAddressScreen extends StatefulWidget {
  static const routeName = '/customer-submit-address';

  @override
  _CustomerSubmitAddressScreenState createState() =>
      _CustomerSubmitAddressScreenState();
}

class _CustomerSubmitAddressScreenState
    extends State<CustomerSubmitAddressScreen> {
  final _addressController = TextEditingController();
  final _pisoController = TextEditingController();
  final _puertaController = TextEditingController();
  bool _verifiedAddress = false;
  String _previewImageUrl;
  Map _geolocation;

  Future<void> _getCurrentLocation() async {
    final location = await Location().getLocation();
    _showPreview(location.latitude, location.longitude);
    final generatedAddress = await LocationHelper.getPlaceAddress(
        latitude: location.latitude, longitude: location.longitude);
    _verifiedAddress = true;
    setState(() {
      _addressController.text = generatedAddress;
    });
  }

  void _locationFromAddress() async {
    if (_addressController.text.isEmpty) return;

    final location =
        await LocationHelper.getPlaceGeolocation(_addressController.text);

    _showPreview(location['lat'], location['lng']);
    _verifiedAddress = true;
  }

  void _showPreview(double lat, double lng) {
    final previewImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitude: lng);
    _geolocation = {'lat': lat, 'lng': lng};
    setState(() {
      _previewImageUrl = previewImageUrl;
    });
  }

  void _submit() async {
    if (_addressController.text.isEmpty) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Direccion no valida'),
          content: Text('Por favor, introduce una direccion'),
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
    }

    if (!_verifiedAddress) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Direccion no verificada'),
          content: Text('Utiliza "Localizame" o "Busca por direccion"'),
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
    }

    Provider.of<CompraService>(context, listen: false).submitDireccionEntrega(
        _addressController.text,
        _pisoController.text,
        _puertaController.text,
        _geolocation,
        _previewImageUrl);

    Navigator.of(context).pushNamed(ConfirmarCompraScreen.routeName);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _pisoController.dispose();
    _puertaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Introduce direccion de entrega'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Introduce tu direccion (o utiliza Localizame)',
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _pisoController,
                      decoration: InputDecoration(
                        labelText: 'Bloque y Piso',
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: _puertaController,
                      decoration: InputDecoration(
                        labelText: 'Puerta',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Card(
                      color: Theme.of(context).accentColor,
                      child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  size: 80,
                                  color: Theme.of(context).canvasColor,
                                ),
                                Text('Localizame',
                                    style: TextStyle(
                                        color: Theme.of(context).canvasColor)),
                              ],
                            ),
                          ),
                          onTap: _getCurrentLocation),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Theme.of(context).accentColor,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.map,
                                size: 80,
                                color: Theme.of(context).canvasColor,
                              ),
                              Text(
                                'Busca por direccion',
                                style: TextStyle(
                                  color: Theme.of(context).canvasColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: _locationFromAddress,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Theme.of(context).accentColor),
                ),
                child: _previewImageUrl == null
                    ? Text(
                        'La vista previa de la localizacion aparecera aqui',
                        textAlign: TextAlign.center,
                      )
                    : Image.network(
                        _previewImageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
              ),
              SizedBox(height: 20),
              ButtonTheme(
                height: 80,
                child: RaisedButton(
                  child: Text(
                    'Confirmar direccion',
                    style: TextStyle(
                        color: Theme.of(context).canvasColor, fontSize: 20),
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: _submit,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
