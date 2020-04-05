import 'package:flutter/material.dart';
import 'package:vengo_del_super/styles/font_styles.dart';

class UserDataBottomSheetContent extends StatelessWidget {
  const UserDataBottomSheetContent(
      {@required this.localizacionCompleta, @required this.destinatario});

  final Map localizacionCompleta;
  final destinatario;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Informacion destinatario',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: <Widget>[
                Text('Nombre', style: confirmarPedidoBottomSheetTitle),
                Text(destinatario['nombre'],
                    style: confirmarPedidoBottomSheetContent),
              ],
            ),
            Column(
              children: <Widget>[
                Text('Contacto', style: confirmarPedidoBottomSheetTitle),
                Text(destinatario['telefono'],
                    style: confirmarPedidoBottomSheetContent),
              ],
            ),
          ],
        ),
        Divider(),
        Text(
          'Informacion Destino',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Divider(),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Direccion completa',
                        style: confirmarPedidoBottomSheetTitle),
                    Text(localizacionCompleta['direccion'], style: confirmarPedidoBottomSheetContent)
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('Bloque/piso',
                            style: confirmarPedidoBottomSheetTitle),
                        Text(localizacionCompleta['piso'] == '' ? 'N/A' : localizacionCompleta['piso'],
                            style: confirmarPedidoBottomSheetContent),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text('Puerta', style: confirmarPedidoBottomSheetTitle),
                        Text(localizacionCompleta['puerta'] == '' ? 'N/A' : localizacionCompleta['puerta'],
                            style: confirmarPedidoBottomSheetContent),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
