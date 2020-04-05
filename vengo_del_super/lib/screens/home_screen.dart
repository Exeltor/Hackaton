import 'package:flutter/material.dart';
import 'package:vengo_del_super/screens/lista_listas_screen.dart';
import 'package:vengo_del_super/styles/font_styles.dart';
import 'package:vengo_del_super/widgets/drawer.dart';

import 'lista_compra_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vengo del Super'),
      ),
      drawer: AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Center(
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          Flexible(
            flex: 2,
            child: Card(
              child: InkWell(
                child: Center(
                  child: Text(
                    'Necesito compra',
                    style: homeCardStyle,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(ListaCompraScreen.routeName);
                },
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Card(
              child: InkWell(
                child: Center(
                  child: Text(
                    'Puedo hacer la compra',
                    style: homeCardStyle,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(ListadeListasScreen.routeName);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
